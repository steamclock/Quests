//
//  AppDelegate.swift
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
import ServiceManagement
import SwiftyUserDefaults
import Valet

extension Notification.Name {
    static let killLauncher = Notification.Name("killLauncher")
}

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    @IBOutlet weak var window: NSWindow!

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        NSUserNotificationCenter.default.delegate = self
        UserDefaults.standard.register(defaults: ["NSApplicationCrashOnExceptions": true])

        AnalyticsModel.shared.appStarted()

        // Check if the launcher app is running and kill it if it is.
        let launcherId = "com.steamclock.QuestsLauncher"
        let isRunning = !NSWorkspace.shared.runningApplications.filter { $0.bundleIdentifier == launcherId }.isEmpty

        if isRunning {
            DistributedNotificationCenter.default().post(name: .killLauncher, object: Bundle.main.bundleIdentifier!)
        }

        // If they haven't launched before, turn on any default settings
        if !Defaults[.hasLaunchedBefore] {
            Defaults[.launchAtLogin] = false
            Defaults[.hasLaunchedBefore] = true
        }

        // If they've allowed us to collect system info send it off
        if Defaults[.sendSystemInfo] {
            AnalyticsModel.shared.sendSystemInfo()
        }
    }
}

extension AppDelegate: NSUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: NSUserNotificationCenter, didActivate notification: NSUserNotification) {
        guard let urlString = notification.identifier, let url = URL(string: urlString) else {
            // identifier is the url
            return
        }

        DispatchQueue.main.async {
            AnalyticsModel.shared.ticketOpened(type: nil)
            NSWorkspace.shared.open(url)
        }
    }

    func userNotificationCenter(_ center: NSUserNotificationCenter, shouldPresent notification: NSUserNotification) -> Bool {
        // always show a notification
        return true
    }
}

extension Valet {
    static let shared = Valet.valet(with: Identifier(nonEmpty: "Quests")!, accessibility: .whenUnlocked)
    static let tokenKey = "helphubValetToken"
}
