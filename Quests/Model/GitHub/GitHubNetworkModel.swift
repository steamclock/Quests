//
//  GitHubNetworkModel.swift
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
import SwiftyUserDefaults
import Valet

extension ApolloClient {
    static let endpoint = URL(string: "https://api.github.com/graphql")!

    static func createWithAuth(_ token: String) -> ApolloClient {
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = ["Authorization": "token \(token)"]

        let client = URLSessionClient(sessionConfiguration: configuration)
        return ApolloClient(networkTransport: HTTPNetworkTransport(url: endpoint, client: client))
    }
}

class GitHubNetworkModel: SourceNetworkModel {
    private var apolloClients = [Token: ApolloClient]()
    private var tempClient: ApolloClient?

    init() {
        Defaults[.tokens].filter { $0.source == .github }.forEach { gitHubToken in
            if let token = try? Valet.shared.string(forKey: gitHubToken.key) {
                apolloClients[gitHubToken] = ApolloClient.createWithAuth(token)
            }
        }
    }

    private func client(for token: String) -> ApolloClient {
        ApolloClient.createWithAuth(token)
    }

    private func client(for token: Token) -> ApolloClient? {
        if let client = apolloClients[token] {
            return client
        }

        if let valetKey = try? Valet.shared.string(forKey: token.key) {
            let newClient = ApolloClient.createWithAuth(valetKey)
            apolloClients[token] = newClient
            return newClient
        }

        return nil
    }

    func authenticateUser(token: String, jiraAuthInfo: JiraAuthInfo? = nil, onSuccess: @escaping (String, String?) -> Void, onFailure: @escaping (NetableError) -> Void) {
        tempClient = client(for: token)
        tempClient?.fetch(query: AuthenticateQuery(), cachePolicy: .fetchIgnoringCacheData) { result in
            if let error = result.error as? Apollo.GraphQLHTTPResponseError {
                onFailure(NetableError.httpError(error.response.statusCode, nil))
                return
            }

            guard let result = try? result.get().data?.viewer, let username = result?.login else {
                onFailure(NetableError.noData)
                return
            }

            onSuccess(username, nil)
        }
    }

    func testToken(token: String, username: String, onSuccess: @escaping () -> Void, onFailure: @escaping (NetableError) -> Void) {
        tempClient = client(for: token)
        tempClient?.fetch(query: GetTicketsQuery(queryString: "assignee:\(username) state:open", after: nil), cachePolicy: .fetchIgnoringCacheData) { result in
            defer {
                self.tempClient = nil
            }

            if result.error != nil {
                onFailure(NetableError.httpError(400, nil))
                return
            }

            guard let result = try? result.get().data?.search, let edges = result?.edges else {
                onFailure(NetableError.noData)
                return
            }

            if !edges.isEmpty {
                onSuccess()
                return
            }

            onFailure(NetableError.httpError(003, nil))
        }
    }

    func getWatchedRepos(token: Token, onSuccess: @escaping ([Repository]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        var repos = [Repository]()

        func paginatedFetchWatched(query: GetWatchedReposQuery) {
            client(for: token)?.fetch(query: query, cachePolicy: .fetchIgnoringCacheData) { result in

                if result.error != nil {
                    if let graphError = result.error as? GraphQLHTTPResponseError {
                        onFailure(NetableError.httpError(graphError.response.statusCode, nil))
                    } else {
                        onFailure(NetableError.httpError(400, nil))
                    }
                    return
                }

                guard let response = try? result.get().data?.viewer.watching, let edges = response?.edges else {
                    onFailure(NetableError.noData)
                    return
                }

                for edge in edges {
                    guard let repo = edge?.node else {
                        LogManager.shared.log("Failed to unwrap repo info from response. Was given \(String(describing: edge))")
                        return
                    }

                    if !repo.isArchived {
                        let newRepo = Repository(name: repo.name, source: .github, url: repo.url, username: token.username, owner: repo.owner.login)
                        repos.append(newRepo)
                    }
                }

                if let hasNextPage = response?.pageInfo.hasNextPage,
                    let endCursor = response?.pageInfo.endCursor,
                        hasNextPage {
                    paginatedFetchWatched(query: GetWatchedReposQuery(after: endCursor))
                } else {
                    onSuccess(repos)
                }
            }
        }

        paginatedFetchWatched(query: GetWatchedReposQuery(after: ""))
    }

    func getTickets(token: Token, onSuccess: @escaping ([Repository: [Ticket]]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        getTicketsWith(
            query: "assignee:\(token.username) state:open",
            token: token,
            tickets: [:],
            onSuccess: { tickets in
                self.getReviewRequests(
                    token,
                    tickets: tickets,
                    onSuccess: { tickets in
                        if Defaults[.hideAuthored] {
                            onSuccess(tickets)
                        } else {
                            self.getAuthoredPRs(token, tickets: tickets, onSuccess: onSuccess, onFailure: onFailure)
                        }
                    },
                    onFailure: onFailure
                )
            },
            onFailure: onFailure
        )
    }

    private func getAuthoredPRs(_ token: Token, tickets: [Repository: [Ticket]], onSuccess: @escaping ([Repository: [Ticket]]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        getTicketsWith(query: "type:pr state:open author:\(token.username)", token: token, type: .authored, tickets: tickets, onSuccess: onSuccess, onFailure: onFailure)
    }

    private func getReviewRequests(_ token: Token, tickets: [Repository: [Ticket]], onSuccess: @escaping ([Repository: [Ticket]]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        getTicketsWith(query: "type:pr state:open review-requested:\(token.username)", token: token, type: .reviewRequest, tickets: tickets, onSuccess: onSuccess, onFailure: onFailure)
    }

    private func getTicketsWith(
            query: String,
            after: String? = nil,
            token: Token,
            type: TicketType? = nil,
            tickets: [Repository: [Ticket]],
            onSuccess: @escaping ([Repository: [Ticket]]) -> Void,
            onFailure: @escaping (NetableError) -> Void) {
        guard let client = client(for: token) else {
            onFailure(NetableError.httpError(001, "Failed to get client, probably due to a token error.".data(using: .utf8)))
            return
        }

        client.fetch(query: GetTicketsQuery(queryString: query, after: after), cachePolicy: .fetchIgnoringCacheData) { result in
            var newTickets = tickets
            if result.error != nil {
                if let graphError = result.error as? GraphQLHTTPResponseError {
                    onFailure(NetableError.httpError(graphError.response.statusCode, nil))
                } else {
                    onFailure(NetableError.httpError(400, nil))
                }
                return
            }

            guard let response = try? result.get().data?.search, let edges = response?.edges else {
                onFailure(NetableError.noData)
                return
            }

            func parseNode(_ node: GetTicketsQuery.Data.Search.Edge.Node?) -> (ticket: Ticket, repository: Repository)? {
                if let issue = node?.asIssue?.fragments.issueDetails, !Defaults[.onlyShowPRs] && !issue.repository.isArchived {
                    let repo = Repository(name: issue.repository.name, source: .github, url: issue.repository.url, username: token.username, owner: issue.repository.owner.login)

                    let assigner = issue.timeline.nodes?.last??.fragments.assignedDetails?.actor?.login
                    let assignee = issue.timeline.nodes?.last??.fragments.assignedDetails?.user?.login
                    let selfAssigned = assigner == assignee

                    let newTicket = Ticket(
                        labels: issue.labels!.edges.map {
                            var labels = [Label]()

                            for element in $0 {
                                guard let label = element?.node?.fragments.labelDetails else { continue }
                                labels.append(Label(title: label.name, color: NSColor(hex: label.color)))
                            }
                            return labels
                        }!,
                        name: issue.title,
                        repoName: repo.name,
                        selfAssigned: selfAssigned,
                        source: .github,
                        type: type ?? .issue,
                        updatedAt: Formatter.iso8601.date(from: issue.updatedAt) ?? Date(timeIntervalSince1970: 0),
                        url: issue.url
                    )
                    return (ticket: newTicket, repository: repo)
                } else if let pr = node?.asPullRequest?.fragments.prDetails, !pr.repository.isArchived {
                    let repo = Repository(name: pr.repository.name, source: .github, url: pr.repository.url, username: token.username, owner: pr.repository.owner.login)

                    let assigner = pr.timeline.nodes?.last??.fragments.assignedDetails?.actor?.login
                    let assignee = pr.timeline.nodes?.last??.fragments.assignedDetails?.user?.login
                    let selfAssigned = assigner == assignee

                    let newTicket = Ticket(
                        labels: pr.labels!.edges.map {
                            var labels = [Label]()

                            for element in $0 {
                                guard let label = element?.node?.fragments.labelDetails else { continue }
                                labels.append(Label(title: label.name, color: NSColor(hex: label.color)))
                            }
                            return labels
                        }!,
                        name: pr.title,
                        repoName: repo.name,
                        selfAssigned: selfAssigned,
                        source: .github,
                        type: type ?? .pullRequest,
                        updatedAt: Formatter.iso8601.date(from: pr.updatedAt) ?? Date(timeIntervalSince1970: 0),
                        url: pr.url
                    )
                    return (ticket: newTicket, repository: repo)
                }

                return nil
            }

            for edge in edges {
                if let result = parseNode(edge?.node) {
                    newTickets.insert(ticket: result.ticket, forKey: result.repository)
                }
            }

            if let hasNextPage = response?.pageInfo.hasNextPage,
                let endCursor = response?.pageInfo.endCursor,
                hasNextPage {
                self.getTicketsWith(query: query, after: endCursor, token: token, type: type, tickets: newTickets, onSuccess: onSuccess, onFailure: onFailure)
            } else {
                onSuccess(newTickets)
            }
        }
    }
}
