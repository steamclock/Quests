//
//  DefaultsKeys.swift
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

import SwiftyUserDefaults

extension DefaultsKeys {
    static let hasLaunchedBefore = DefaultsKey<Bool>("hasLaunchedBefore", defaultValue: false)

    static let launchAtLogin = DefaultsKey<Bool>("launchAtLogin", defaultValue: false)
    static let enableNotifications = DefaultsKey<Bool>("enableNotifications", defaultValue: false)
    static let alwaysShowSubmenus = DefaultsKey<Bool>("alwaysShowSubmenus", defaultValue: false)
    static let onlyShowPRs = DefaultsKey<Bool>("onlyShowPRs", defaultValue: false)
    static let hideAuthored = DefaultsKey<Bool>("hideAuthored", defaultValue: false)
    static let dontShowLabels = DefaultsKey<Bool>("dontShowLabels", defaultValue: false)
    static let ignoredRepos = DefaultsKey<[String]>("ignoredRepos", defaultValue: [])
    static let username = DefaultsKey<String?>("username")
    static let tokens = DefaultsKey<[Token]>("tokens", defaultValue: [])
    static let updateLastChecked = DefaultsKey<Date?>("updateLastChecked")
    static let dailyUseLastLogged = DefaultsKey<Date?>("dailyUseLastLogged")
    static let sendSystemInfo = DefaultsKey<Bool>("sendSystemInfo", defaultValue: false)

    static let ignoreJIRADone = DefaultsKey<Bool>("ignoreJIRADone", defaultValue: false)
    static let ignoredJIRAStatuses = DefaultsKey<[String]>("ignoredJIRAStatuses", defaultValue: [])

    // MARK: Helper Functions

    static func add(token: Token) {
        var tokensSet = Set<Token>(Defaults[.tokens])
        tokensSet.update(with: token)
        Defaults[.tokens] = Array(tokensSet)
    }

    static func remove(token: Token) {
        var tokensSet = Set(Defaults[.tokens])
        tokensSet.remove(token)
        Defaults[.tokens] = Array(tokensSet)
    }

    static func addIgnored(repo: String) {
        var currentSet = Set(Defaults[.ignoredRepos])
        currentSet.insert(repo)
        Defaults[.ignoredRepos] = Array(currentSet)
    }

    static func removeIgnored(repo: String) {
        var currentSet = Set(Defaults[.ignoredRepos])
        currentSet.remove(repo)
        Defaults[.ignoredRepos] = Array(currentSet)
    }
}
