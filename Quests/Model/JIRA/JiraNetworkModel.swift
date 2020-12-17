//
//  JiraNetworkModel.swift
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

import Alamofire
import Foundation
import Netable
import SwiftyUserDefaults
import Valet

struct JiraAuthInfo {
    let user: String
    let domain: String
}

class JiraNetworkModel: SourceNetworkModel {
    private var api: JiraAPI?

    func authenticateUser(token: String, jiraAuthInfo: JiraAuthInfo? = nil, onSuccess: @escaping (String, String?) -> Void, onFailure: @escaping (NetableError) -> Void) {
        guard let jiraInfo = jiraAuthInfo else {
            onFailure(NetableError.noData)
            return
        }

        if api == nil { initApi(token: token, info: jiraInfo) }
        api!.request(JiraAPI.AuthRequest()) { result in
            switch result {
            case .success(let user):
                // don't need to check for permissions like on GitLab, JIRA doesn't care
                onSuccess(user.username, jiraInfo.domain)
            case .failure(let error):
                LogManager.shared.log("JIRA auth error: \(error)")
                onFailure(error)
            }
        }
    }

    func testToken(token: String, username: String, onSuccess: @escaping () -> Void, onFailure: @escaping (NetableError) -> Void) {
        onSuccess()
    }

    func getWatchedRepos(token: Token, onSuccess: @escaping ([Repository]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        // Not sure JIRA has the concept of repos like we want. Will revisit when we add JIRA support back.
        onSuccess([])
    }

    func getTickets(token: Token, onSuccess: @escaping ([Repository: [Ticket]]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        guard let tokenString = try? Valet.shared.string(forKey: token.key),
                let domain = token.domain else {
            onFailure(NetableError.noData)
            return
        }

        let auth = JiraAuthInfo(user: token.username, domain: domain)
        if api == nil { initApi(token: tokenString, info: auth) }
        api!.request(JiraAPI.GetIssues()) { result in
            switch result {
            case .success(let response):
                var newTickets = [Repository: [Ticket]]()

                var ignoredStatuses = Defaults[.ignoredJIRAStatuses]
                if Defaults[.ignoreJIRADone] { ignoredStatuses.append("done") }

                for issue in response.issues {
                    // Ignore tickets with banned statuses
                    guard !ignoredStatuses.contains(issue.fields.status.name.uppercased()) else {
                        continue
                    }
                    newTickets.insert(ticket: issue.toTicket(domain: domain), forKey: issue.fields.project.toRepo(domain: domain))
                }

                onSuccess(newTickets)
            case .failure(let error):
                onFailure(error)
            }
        }
    }

    // MARK: Helper Functions

    internal func initApi(token: String, info: JiraAuthInfo) {
        api = JiraAPI(domain: info.domain)
        let authEncodedString = Data("\(info.user):\(token)".utf8).base64EncodedString()
        api?.headers["Authorization"] = "Basic \(authEncodedString)"
    }
}
