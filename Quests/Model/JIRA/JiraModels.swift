//
//  JiraModels.swift
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
struct Jira {
    struct Response: Decodable {
        let total: Int
        let issues: [Issue]
    }

    struct Issue: Decodable {
        let fields: Fields
        let key: String

        enum CodingKeys: String, CodingKey {
            case fields
            case key
        }

        func toTicket(domain: String) -> Ticket {
            Ticket(
                labels: fields.labels.map {
                    Label(title: $0, color: NSColor(hex: "0747A6"))
                },
                name: fields.name,
                repoName: fields.project.name,
                selfAssigned: fields.assignee.username == fields.author.username,
                source: .jira,
                type: .issue,
                updatedAt: Formatter.iso8601.date(from: fields.updatedAt) ?? Date(),
                url: "https://\(domain).atlassian.net/browse/\(key)"
            )
        }
    }

    struct Fields: Decodable {
        let assignee: User
        let author: User
        let labels: [String]
        let name: String
        let project: Project
        let status: Status
        let updatedAt: String

        enum CodingKeys: String, CodingKey {
            case assignee
            case author = "creator"
            case labels
            case name = "summary"
            case project
            case status
            case updatedAt = "updated"
        }
    }

    struct Status: Decodable {
        let name: String
    }

    struct Project: Decodable {
        let key: String
        let name: String

        func toRepo(domain: String) -> Repository {
            Repository(name: "\(domain)/\(name)", source: .jira, url: "https://\(domain).atlassian.net/projects/\(key)/issues/", username: "", owner: domain)
        }
    }

    struct User: Decodable, Equatable {
        let username: String

        enum CodingKeys: String, CodingKey {
            case username = "emailAddress"
        }

        static func == (lhs: User, rhs: User) -> Bool {
            lhs.username == rhs.username
        }
    }
}
