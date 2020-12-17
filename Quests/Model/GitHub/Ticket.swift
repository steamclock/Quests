//
//  Ticket.swift
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
import Cocoa
import Foundation

enum TicketType: Int, Decodable {
    case issue = 0
    case authored
    case reviewRequest
    case pullRequest

    var image: NSImage? {
        switch self {
        case .authored: return NSImage(named: NSImage.Name(rawValue: "Pull-Request-Authored"))
        case .issue: return nil
        case .pullRequest: return NSImage(named: NSImage.Name(rawValue: "Pull-Request"))
        case .reviewRequest: return NSImage(named: NSImage.Name(rawValue: "Review-Request"))
        }
    }

    var description: String {
        switch self {
        case .authored, .pullRequest: return "Pull Request"
        case .issue: return "Issue"
        case .reviewRequest: return "Review Request"
        }
    }
}

struct Ticket {
    let labels: [Label]
    let name: String
    let repoName: String
    let selfAssigned: Bool
    let source: Source
    let type: TicketType
    let updatedAt: Date
    let url: String

    enum CodingKeys: String, CodingKey {
        case labels
        case name
        case repoName
        case selfAssigned
        case type
        case updatedAt
        case url
    }
}

extension Ticket: Decodable {
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        labels = try values.decode([Label].self, forKey: .labels)
        name = try values.decode(String.self, forKey: .name)
        repoName = try values.decode(String.self, forKey: .repoName)
        type = try values.decode(TicketType.self, forKey: .type)

        // Since we're faking this data, it doesn't need a lot of the hidden fields
        selfAssigned = false
        source = .github
        url = ""
        updatedAt = Date()
    }
}

extension Ticket: Equatable {
    static func == (lhs: Ticket, rhs: Ticket) -> Bool {
        lhs.name == rhs.name &&
            lhs.repoName == rhs.repoName
    }
}
