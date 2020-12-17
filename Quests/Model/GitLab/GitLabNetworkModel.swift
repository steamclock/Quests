//
//  GitLabNetworkModel.swift
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
import SwiftyJSON
import SwiftyUserDefaults
import Valet

class GitLabNetworkModel: SourceNetworkModel {
    private let api = GitLabAPI()

    func authenticateUser(token: String, jiraAuthInfo: JiraAuthInfo? = nil, onSuccess: @escaping (String, String?) -> Void, onFailure: @escaping (NetableError) -> Void) {
        api.headers["Private-Token"] = token
        api.request(GitLabAPI.AuthRequest()) { result in
            switch result {
            case .success(let user):
                // Need to go get issues to make sure our token has enough permissions to see things.
                self.api.request(GitLabAPI.TestGetIssues()) { result in
                    switch result {
                    case .success:
                        onSuccess(user.username, nil)
                    case .failure(let error):
                        onFailure(error)
                    }
                }
            case .failure(let error):
                onFailure(error)
            }
        }
    }

    func testToken(token: String, username: String, onSuccess: @escaping () -> Void, onFailure: @escaping (NetableError) -> Void) {
        // GitLab isn't dumb and will pass back for 403 error, so we don't need this.
        onSuccess()
    }

    func getWatchedRepos(token: Token, onSuccess: @escaping ([Repository]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        api.request(GitLabAPI.GetWatchedProjects()) { result in
            switch result {
            case .success(let repos):
                var allRepos = [Repository]()

                for repo in repos {
                    allRepos.append(Repository(name: repo.name, source: .gitlab, url: repo.url, username: token.username, owner: repo.owner.name))
                }
                onSuccess(allRepos)
            case .failure(let error):
                onFailure(error)
            }
        }
    }

    func getTickets(token: Token, onSuccess: @escaping ([Repository: [Ticket]]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        // Make sure we've got a personal access token for requests
        guard let tokenString = try? Valet.shared.string(forKey: token.key) else {
            onFailure(NetableError.noData)
            return
        }
        api.headers["Private-Token"] = tokenString

        // Next we need to get a list of all the projects the user can see since future requests will only reference them by id
        getProjects(
            username: token.username,
            onSuccess: { projects in
                self.getMergeRequests(
                    token: tokenString,
                    onSuccess: { mergeRequests in
                        self.getIssues(
                            onSuccess: { issues in
                                var tickets = [Repository: [Ticket]]()
                                mergeRequests.forEach { mergeRequest in
                                    if let project = projects.first(where: { $0.id == mergeRequest.projectID }) {
                                        tickets.insert(ticket: mergeRequest.toTicket(), forKey: project.toRepo())
                                    }
                                }

                                issues.forEach { issue in
                                    if let issueProject = projects.first(where: { $0.id == issue.projectID }) {
                                        tickets.insert(ticket: issue.toTicket(), forKey: issueProject.toRepo())
                                    }
                                }

                                onSuccess(tickets)
                            },
                            onFailure: onFailure
                        )
                    },
                    onFailure: { error in
                        onFailure(error)
                    }
                )
            }, onFailure: { error in
                onFailure(error)
            }
        )
    }

    // MARK: Helper Functions

    private func getProjects(username: String, onSuccess: @escaping ([GitLab.Project]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        api.request(GitLabAPI.GetProjects()) { result in
            switch result {
            case .success(let projects):
                let projectsWithUsername: [GitLab.Project] = projects.map {
                    var newProject = $0
                    newProject.username = username
                    return newProject
                }.filter {
                    !$0.archived
                }
                onSuccess(projectsWithUsername)
            case .failure(let error):
                onFailure(error)
            }
        }
    }

    private func getIssues(onSuccess: @escaping ([GitLab.Issue]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        api.request(GitLabAPI.GetIssues()) { result in
            switch result {
            case .success(let issues):
                onSuccess(issues)
            case .failure(let error):
                onFailure(error)
            }
        }
    }

    private func getMergeRequests(token: String, onSuccess: @escaping ([GitLab.MergeRequest]) -> Void, onFailure: @escaping (NetableError) -> Void) {
        api.request(GitLabAPI.GetMergeRequests()) { assignedResult in
            switch assignedResult {
            case .success(let assignedRequests):
                if Defaults[.hideAuthored] {
                    onSuccess(assignedRequests as [GitLab.MergeRequest])
                } else {
                    self.api.request(GitLabAPI.GetAuthoredMergeRequests()) { authoredResult in
                        switch authoredResult {
                        case .success(let authoredRequests):
                            var allRequests = assignedRequests as [GitLab.MergeRequest]
                            allRequests.append(contentsOf: authoredRequests)
                            onSuccess(allRequests)
                        case .failure(let error):
                            onFailure(error)
                        }
                    }
                }
            case .failure(let error):
                onFailure(error)
            }
        }
    }
}
