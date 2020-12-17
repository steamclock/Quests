//
//  JiraAPI.swift
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

import Foundation
import Netable

class JiraAPI: Netable {
    init(domain: String) {
        super.init(baseURL: URL(string: "https://\(domain).atlassian.net/rest/api/3/")!)
        headers["Accept"] = "application/json"
    }
}

// swiftlint:disable nesting
extension JiraAPI {
    struct AuthRequest: Request {
        typealias Parameters = [String: String]
        typealias RawResource = Jira.User

        public var method: HTTPMethod { .get }

        public var path: String { "myself" }

        public var parameters: [String: String] { ["expand": "groups"] }
    }

    struct GetIssues: Request {
        typealias Parameters = [String: String]
        typealias RawResource = Jira.Response

        public var method: HTTPMethod { .get }

        public var path: String { "search" }

        public var parameters: [String: String] {
            ["jql": "assignee=currentUser()"]
        }
    }
}
