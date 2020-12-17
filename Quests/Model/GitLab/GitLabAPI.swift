//
//  GitLabAPI.swift
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

class GitLabAPI: Netable {
    init() {
        super.init(baseURL: URL(string: "https://gitlab.com/api/v4/")!)
        headers["Accept"] = "application/json"
    }
}

// swiftlint:disable nesting
extension GitLabAPI {
    struct AuthRequest: Request {
        typealias Parameters = Empty
        typealias RawResource = GitLab.User

        public var method: HTTPMethod { .get }

        public var path: String {
            "user/"
        }
    }

    struct TestGetIssues: Request {
        typealias Parameters = [String: String]
        typealias RawResource = [GitLab.Issue]

        public var method: HTTPMethod { .get }

        public var path: String {
            "issues"
        }

        public var parameters: [String: String] {
            [
                "scope": "assigned_to_me",
                "per_page": "1",
                "page": "1"
            ]
        }
    }

    struct GetAuthoredMergeRequests: Request {
        typealias Parameters = [String: String]
        typealias RawResource = [GitLab.MergeRequest] // Paginated Request?
        public var method: HTTPMethod { .get }

        public var path: String {
            "merge_requests"
        }

        public var parameters: [String: String] {
            [
                "state": "opened",
                "scope": "created_by_me"
            ]
        }
    }

    struct GetWatchedProjects: Request {
        typealias Parameters = [String: Bool]
        typealias RawResource = [GitLab.Project]

        public var method: HTTPMethod { .get }

        public var path: String {
            "projects"
        }

        public var parameters: [String: Bool] {
            ["membership": true]
        }
    }

    struct GetIssues: Request {
        typealias Parameters = [String: String]
        typealias RawResource = [GitLab.Issue] // Paginated Request?

        public var method: HTTPMethod { .get }

        public var path: String {
            "issues"
        }

        public var parameters: [String: String] {
            [
                "scope": "assigned_to_me"
            ]
        }
    }

    struct GetMergeRequests: Request {
        typealias Parameters = [String: String]
        typealias RawResource = [GitLab.MergeRequest] // Paginated Request?

        public var method: HTTPMethod { .get }

        public var path: String {
            "merge_requests"
        }

        public var parameters: [String: String] {
            ["state": "opened"]
        }
    }

    struct GetProjects: Request {
        typealias Parameters = [String: String]
        typealias RawResource = [GitLab.Project] // Paginated Request?

        public var method: HTTPMethod { .get }

        public var path: String {
            "projects"
        }

        public var parameters: [String: String] {
            [
                "simple": "false",
                "with_issues_enabled": "true",
                "archived": "false",
                "membership": "true"
            ]
        }
    }
}
