//
//  Repository.swift
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
import SwiftyUserDefaults

struct RepoOwner {
    let name: String
    var repos: [Repository]

    static func sortRepos(_ repos: [Repository]) -> [RepoOwner] {
        repos.reduce([RepoOwner]()) { owners, repo in
            var owners = owners
            if let ownerIndex = owners.firstIndex(where: { $0.name == repo.owner }) {
                owners[ownerIndex].repos.append(repo)
                // I hate that we're sorting every time we add a new repo here, this should happen later but I can't get it to work.
                owners[ownerIndex].repos.sort { $0.name.lowercased() < $1.name.lowercased() }
            } else {
                owners.append(RepoOwner(name: repo.owner, repos: [repo]))
            }
            return owners
        }.sorted {
            $0.name.lowercased() < $1.name.lowercased()
        }
    }
}

struct Repository {
    let name: String
    let source: Source
    let url: String
    let username: String
    let owner: String

    var allAssignedLink: String {
        switch source {
        case .github:
            return url + "/issues?q=is%3Aopen+assignee%3A\(username)"
        case .gitlab:
            return url + "/issues?scope=all&state=opened&assignee_username=\(username)"
        case .jira:
            return url
        }
    }
}

extension Repository: Equatable {
    static func == (lhs: Repository, rhs: Repository) -> Bool {
        lhs.name == rhs.name && lhs.url == rhs.url
    }
}

extension Repository: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(name)
        hasher.combine(url)
    }
}
