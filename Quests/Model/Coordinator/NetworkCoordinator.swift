//
//  NetworkingCoordinator.swift
//
//  Copyright © 2020 Steamclock Software.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Apollo
import Foundation
import Netable
import Reachability
import SwiftyUserDefaults
import Valet

protocol SourceNetworkModel {
    /// onSuccess should pass the username of the authenicated user
    func authenticateUser(token: String, jiraAuthInfo: JiraAuthInfo?, onSuccess: @escaping (String, String?) -> Void, onFailure: @escaping (NetableError) -> Void)
    func testToken(token: String, username: String, onSuccess: @escaping () -> Void, onFailure: @escaping (NetableError) -> Void)
    func getTickets(token: Token, onSuccess: @escaping ([Repository: [Ticket]]) -> Void, onFailure: @escaping (NetableError) -> Void)
    func getWatchedRepos(token: Token, onSuccess: @escaping ([Repository]) -> Void, onFailure: @escaping (NetableError) -> Void)
}

struct NetworkError {
    let statusCode: Int
    let message: String
}

class NetworkCoordinator {
    // Enforce Singleton
    static let shared = NetworkCoordinator()
    static let privacyPolicyURL = URL(string: "https://steamclock.com/privacy")!

    private init() {
        do {
            try reachability?.startNotifier()
        } catch {
            LogManager.shared.log("Unable to start reachability notifier")
        }
    }

    private let gitHubNetworkModel = GitHubNetworkModel()
    private let gitLabNetworkModel = GitLabNetworkModel()
    private let jiraNetworkModel = JiraNetworkModel()
    private let reachability = try? Reachability()

    private func getNetworkModel(for source: Source) -> SourceNetworkModel {
        switch source {
        case .github: return gitHubNetworkModel
        case .gitlab: return gitLabNetworkModel
        case .jira: return jiraNetworkModel
        }
    }

    var tokenErrors = [Token: [NetworkError]]()

    func contactSupportService() -> NSSharingService? {
        let versionString = Bundle.versionString
        let sharingService = NSSharingService(named: .composeEmail)
        sharingService?.recipients = ["support@steamclock.com"]
        sharingService?.subject = "Quests v\(versionString) Feedback"
        return sharingService
    }

    func authenticateUser(source: Source, token: String, jiraAuthInfo: JiraAuthInfo?, onSuccess: @escaping () -> Void, onFailure: @escaping (NetworkError) -> Void) {

        guard reachability?.connection != Reachability.Connection.unavailable else {
            onFailure(NetworkError(statusCode: 503, message: "No network connection available."))
            return
        }

        getNetworkModel(for: source).authenticateUser(
            token: token,
            jiraAuthInfo: jiraAuthInfo,
            onSuccess: { username, domain in
                let newToken = Token(created: Date(), source: source, username: username, domain: domain)
                guard !Defaults[.tokens].contains(newToken) else {
                    onFailure(NetworkError(statusCode: 0, message: "You can't add the same account twice."))
                    return
                }

                // Now that we know the token is valid, we need to check to make sure it's been given the proper scope
                self.getNetworkModel(for: source).testToken(
                    token: token,
                    username: username,
                    onSuccess: {

                        do {
                            try Valet.shared.setString(token, forKey: newToken.key)
                            DefaultsKeys.add(token: newToken)
                            AnalyticsModel.shared.tokenAdded(source: source)
                            onSuccess()
                        } catch let keychainError {
                            onFailure(NetworkError(statusCode: 002, message: keychainError.localizedDescription))
                        }
                    },
                    onFailure: { error in
                        // It's kind of janky, but we need to pass the username back here
                        let error = NetworkError(statusCode: 003, message: username)
                        onFailure(error)
                    }
                )
            },
            onFailure: { error in
                onFailure(self.process(error, source: source))
            }
        )
    }

    func getWatchedRepos(onSuccess: @escaping ([Repository]) -> Void, onFailure: @escaping (NetworkError) -> Void) {
        var allRepos = [Repository]()
        var queriesToRun = 0

        guard reachability?.connection != Reachability.Connection.unavailable else {
            onFailure(NetworkError(statusCode: 503, message: "No network connection available."))
            return
        }

        func queryComplete() {
            queriesToRun -= 1

            if queriesToRun == 0 {
                onSuccess(allRepos)
            }
        }

        for token in Defaults[.tokens] {
            queriesToRun += 1
            getNetworkModel(for: token.source).getWatchedRepos(
                token: token,
                onSuccess: { repos in
                    self.tokenErrors[token] = []
                    allRepos.append(contentsOf: repos)
                    queryComplete()
                },
                onFailure: { error in
                    queriesToRun -= 1
                    let processedError = self.process(error, source: token.source)
                    self.add(error: processedError, toToken: token)
                    onFailure(processedError)
                }
            )
        }
    }

    func getTickets(onSuccess: @escaping ([Repository: [Ticket]]) -> Void, onFailure: @escaping (NetworkError) -> Void) {
        var allTickets = [Repository: [Ticket]]()
        var queriesToRun = 0

        func queryComplete() {
            queriesToRun -= 1

            if queriesToRun == 0 {
                onSuccess(allTickets)
            }
        }

        guard reachability?.connection != Reachability.Connection.unavailable else {
            onFailure(NetworkError(statusCode: 503, message: "No network connection available."))
            return
        }

        guard !Defaults[.tokens].isEmpty else {
            onFailure(NetworkError(statusCode: -100, message: "No tokens added."))
            return
        }

        for token in Defaults[.tokens] {
            queriesToRun += 1

            getNetworkModel(for: token.source).getTickets(
                token: token,
                onSuccess: { tickets in
                    self.tokenErrors[token] = []
                    allTickets.merge(tickets) { old, new in
                        var oldCopy = old
                        oldCopy.append(contentsOf: new)
                        return oldCopy
                    }
                    queryComplete()
                }, onFailure: { error in
                    queriesToRun -= 1
                    let processedError = self.process(error, source: token.source)
                    self.add(error: processedError, toToken: token)
                    onFailure(processedError)
                }
            )
        }
    }

    private func process(_ error: NetableError, source: Source) -> NetworkError {
        var networkError: NetworkError!

        switch error {
        // Our custom token failed notification
        case .httpError(401, _):
            networkError = NetworkError(statusCode: 401, message: "This token is no longer valid. Please remove it then add a new token. (401)")
        case .httpError(403, _):
            networkError = NetworkError(statusCode: 403, message: "Access Forbidden. (403)")
        case .httpError(404, _):
            networkError = NetworkError(statusCode: 404, message: "Domain not found. (404)")
        case .httpError(500, _):
            networkError = NetworkError(statusCode: 500, message: "Something went wrong on the server, please try again. (500)")
        case .httpError(503, _):
            networkError = NetworkError(statusCode: 500, message: "Service unavailable. (503)")
        case .httpError(let code, _):
            networkError = NetworkError(statusCode: code, message: "Something went wrong, please try again. \(code)")
        default:
            networkError = NetworkError(statusCode: 0, message: "Not Connected.")
        }

        AnalyticsModel.shared.networkErrorOccured(networkError.statusCode, message: "\(source.title) error: \(networkError.message)")

        return networkError
    }

    private func add(error: NetworkError, toToken token: Token) {
        if !tokenErrors[token].isNil {
            tokenErrors[token]?.append(error)
        } else {
            tokenErrors[token] = [error]
        }
    }
}
