//
//  GitLabModels.swift
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

import Cocoa

// swiftlint:disable nesting
struct GitLab {
    struct Issue: Decodable {
        let assignees: [GitLab.User]
        let author: GitLab.User
        let projectID: Int
        let title: String
        let updatedAt: String
        let url: String

        // Labels will have to be added later, it seems like /issues just sends back the label name not color as well...

        enum CodingKeys: String, CodingKey {
            case assignees
            case author
            case projectID = "project_id"
            case title
            case updatedAt = "updated_at"
            case url = "web_url"
        }

        func toTicket() -> Ticket {
            // Repo name will be set later since GitLab only supplies projectID for issues
            return Ticket(labels: [], name: title, repoName: "", selfAssigned: assignees.contains(author), source: .gitlab, type: .issue, updatedAt:
                Formatter.iso8601Fractional.date(from: updatedAt) ?? Date(timeIntervalSince1970: 0), url: url)
        }
    }

    struct MergeRequest: Decodable {
        let assignee: GitLab.User?
        let author: GitLab.User
        let projectID: Int
        let title: String
        let updatedAt: String
        let url: String

        // Labels will have to be added later, it seems like /issues just sends back the label name not color as well...

        enum CodingKeys: String, CodingKey {
            case assignee
            case author
            case projectID = "project_id"
            case title
            case updatedAt = "updated_at"
            case url = "web_url"
        }

        func toTicket() -> Ticket {
            // Repo name will be set later since GitLab only supplies projectID for issues
            return Ticket(
                labels: [],
                name: title,
                repoName: "",
                selfAssigned: assignee == author,
                source: .gitlab,
                type: assignee.isNil ? .authored : .pullRequest,
                updatedAt: Formatter.iso8601Fractional.date(from: updatedAt) ?? Date(timeIntervalSince1970: 0),
                url: url
            )
        }
    }

    struct Project: Decodable {
        let archived: Bool
        let id: Int
        let name: String
        let owner: GitLab.Owner
        let url: String
        var username: String?

        enum CodingKeys: String, CodingKey {
            case archived
            case id
            case name
            case owner
            case url = "web_url"
            case username
        }

        func toRepo() -> Repository {
            // TODO: fix this faking a bunch of info
            Repository(name: name, source: .gitlab, url: url, username: username ?? "", owner: owner.name)
        }
    }

    struct User: Decodable, Equatable {
        let username: String

        static func == (lhs: User, rhs: User) -> Bool {
            lhs.username == rhs.username
        }
    }

    struct Owner: Decodable, Equatable {
        let name: String

        static func == (lhs: Owner, rhs: Owner) -> Bool {
            lhs.name == rhs.name
        }
    }
}
