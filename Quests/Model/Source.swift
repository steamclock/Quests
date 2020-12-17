//
//  Source.swift
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

enum Source: String, CaseIterable, Codable {
    case github
    case gitlab
    case jira

    var title: String {
        switch self {
        case .github: return "GitHub"
        case .gitlab: return "GitLab"
        case .jira: return "JIRA"
        }
    }
}

extension Source {
    var largeImage: NSImage? {
        switch self {
        case .github: return NSImage(named: NSImage.Name(rawValue: "Github-Large"))
        case .gitlab: return NSImage(named: NSImage.Name(rawValue: "Gitlab-Large"))
        case .jira: return NSImage(named: NSImage.Name(rawValue: "Jira-Large"))
        }
    }

    var image: NSImage? {
        switch self {
        case .github: return NSImage(named: NSImage.Name(rawValue: "Github-Small"))
        case .gitlab: return NSImage(named: NSImage.Name(rawValue: "Gitlab-Small"))
        case .jira: return NSImage(named: NSImage.Name(rawValue: "Jira-Small"))
        }
    }

    var tokenURL: URL? {
        switch self {
        case .github: return URL(string: "https://github.com/settings/tokens/new?scopes=repo&description=Quests%20for%20Mac")
        case .gitlab: return URL(string: "https://gitlab.com/profile/personal_access_tokens")
        case .jira: return URL(string: "https://id.atlassian.com/manage/api-tokens")
        }
    }
}
