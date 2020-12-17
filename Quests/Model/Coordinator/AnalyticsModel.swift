//
//  AnalyticsModel.swift
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

import CwlUtils
import Foundation
import SwiftyUserDefaults

/*
 * As of our open source release, we've removed Crashlytics and in turn stopped tracking analytics.
 *
 * We've left this in for reference.
 */

enum MenuSetting: String {
    case alwaysSubmenus
    case hideLabels
    case ignoreJIRADone
    case launchAtLogin
    case notifications
    case onlyPRs
    case hideAuthored
    case systemInfo
}

/*
 * Analytics will be removed when we move to open source and Fabric and Crashlytics are both deprecated.
 * Leaving this in for now for reference.
 */

class AnalyticsModel {
    static let shared = AnalyticsModel()

    // Enforce singleton
    private init() {}

    // MARK: Log events

    func appStarted() {}

    func appQuit() {}

    func feedbackSent(_ feedback: String) {}

    func tokenAdded(source: Source) {}

    func ticketOpened(type: TicketType?) {}

    func sendSystemInfo() {}

    func networkErrorOccured(_ statusCode: Int, message: String) {}

    func settingToggled(_ setting: MenuSetting, on: Bool) {}

    func repoToggled(on: Bool) {}

    func logDailyUse() {
        func logUse() {
            var attributes = ["version": Bundle.versionString]

            #if INTERNAL
                attributes["isInternal"] = "true"
            #endif

            Defaults[.dailyUseLastLogged] = Date()
        }

        if let lastLogDate = Defaults[.dailyUseLastLogged] {
            // Log daily use if they haven't yet this calendar day
            if !Calendar.current.isDate(lastLogDate, inSameDayAs: Date()) {
                logUse()
            }
        } else {
            logUse()
        }
    }

    private func getSystemInfo() -> [String: String] {
        [
            "machine": Sysctl.machine,
            "model": Sysctl.model,
            "osRelease": Sysctl.osRelease,
            "osVersion": Sysctl.osVersion
        ]
    }
}
