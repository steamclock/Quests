//
//  StatusMenuViewModel.swift
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

extension Notification.Name {
    static let shouldOpenSettings = Notification.Name(rawValue: "shouldOpenSettings")
    static let startedGetTickets = Notification.Name(rawValue: "startedGetTickets")
}

protocol StatusMenuVMDelegate: AnyObject {
    func statusMenuVMDelegate(_ statusMenuViewModel: StatusMenuViewModel, showErrorMenu menu: NSMenu)
    func statusMenuVMDelegate(_ statusMenuViewModel: StatusMenuViewModel, updatedRepos: [RepoOwner])
    func statusMenuVMDelegate(_ statusMenuViewModel: StatusMenuViewModel, updatedMenu menu: NSMenu, issueCount: Int, prCount: Int)
    func statusMenuVMDelegateShouldShowSettings(_ statusMenuViewModel: StatusMenuViewModel, toPage: Int)
}

class StatusMenuViewModel {
    weak var delegate: StatusMenuVMDelegate? {
        didSet {
            startRetrievingTickets()

            NotificationCenter.default.addObserver(
                self,
                selector: #selector(shouldOpenSettings),
                name: .shouldOpenSettings,
                object: nil
            )
        }
    }

    private var numFailedRequests = 0

    private var refreshTimer: Timer?
    private static let defaultRefreshInterval: TimeInterval = 15

    private var fetchingFirstTickets = true
    private var ticketsByRepo = [Repository: [Ticket]]() {
        didSet {
            updateStoredInfo()
            fetchingFirstTickets = false
        }
    }

    var settingsMenuItem: NSMenuItem {
        let item = NSMenuItem(title: "Settings", action: #selector(settingsPressed(_:)), keyEquivalent: "")
        item.target = self
        return item
    }

    var quitMenuItem: NSMenuItem {
        let item = NSMenuItem(title: "Quit", action: #selector(quitPressed(_:)), keyEquivalent: "")
        item.target = self
        return item
    }

    private var ticketNestThreshold: Int {
        Defaults[.alwaysShowSubmenus] == true ? 0 : 5
    }

    // MARK: Public Methods

    func startRetrievingTickets() {
        #if DEBUG
            // If we're in debug mode and there's data in `Supporting Files/mockdata.json` we should load that instead.
            if loadMockData() { return }
        #endif

        getTickets()
        startTicketRefreshTimer()
    }

    func clearTickets() {
        ticketsByRepo = [:]
    }

    // MARK: Actions

    @objc private func repoItemPressed(_ sender: NSMenuItem) {
        guard let repository = sender.representedObject as? Repository else { return }
        if let url = URL(string: repository.allAssignedLink) {
            NSWorkspace.shared.open(url)
        }
    }

    @objc private func settingsPressed(_ sender: NSMenuItem) {
        delegate?.statusMenuVMDelegateShouldShowSettings(self, toPage: 0)
    }

    @objc private func quitPressed(_ sender: NSMenuItem) {
        AnalyticsModel.shared.appQuit()
        NSApp.terminate(self)
    }

    @objc private func getTickets() {
        AnalyticsModel.shared.logDailyUse()

        var gotWatchedRepos = false
        var gotReposWithTickets = false
        var allRepos = Set<Repository>()

        enum RepoSource {
            case watched
            case tickets
        }

        NotificationCenter.default.post(
            name: .startedGetTickets,
            object: self
        )

        func gotRepos(source: RepoSource, repos: [Repository]) {
            switch source {
            case .tickets: gotReposWithTickets = true
            case .watched: gotWatchedRepos = true
            }

            allRepos = allRepos.union(Set(repos))

            if gotReposWithTickets && gotWatchedRepos {
                self.delegate?.statusMenuVMDelegate(
                    self,
                    updatedRepos: RepoOwner.sortRepos(Array(allRepos))
                )
            }
        }

        NetworkCoordinator.shared.getWatchedRepos(
            onSuccess: { repos in
                gotRepos(source: .watched, repos: repos)
            },
            onFailure: { error in
                // Since we're only using this info to fill out the settings page I think we're okay just noting the error and moving on
                LogManager.shared.log("Failed to get watched repos \(error)")
                AnalyticsModel.shared.networkErrorOccured(error.statusCode, message: "Failed to retrieve watched repos")
            }
        )

        NetworkCoordinator.shared.getTickets(
            onSuccess: { tickets in
                self.numFailedRequests = 0
                if !self.fetchingFirstTickets {
                    let (added, _) = self.calculateTicketsDiff(newTicketsByRepo: tickets)
                    self.scheduleNotifications(forAddedTickets: added.filter { !$0.selfAssigned && $0.type != .authored })
                }
                self.ticketsByRepo = tickets

                gotRepos(source: .tickets, repos: Array(tickets.keys))
            }, onFailure: { error in
                self.numFailedRequests += 1
                LogManager.shared.log("Get tickets request failed. Current error count: \(self.numFailedRequests).  \(error)")

                // Invalidate the current timer and start it again with a slower count
                var requestInterval = StatusMenuViewModel.defaultRefreshInterval
                switch self.numFailedRequests {
                case 1..<4: requestInterval = Double(30 * self.numFailedRequests)
                default: requestInterval = 300
                }
                self.startTicketRefreshTimer(interval: requestInterval)

                // If the error is that we don't have any tokens, update the number of repos we've got
                if error.statusCode == -100 {
                    self.delegate?.statusMenuVMDelegate(self, updatedRepos: [])
                }

                self.delegate?.statusMenuVMDelegate(self, showErrorMenu: self.getNetworkErrorMenu(error))
            }
        )
    }

    @objc private func shouldOpenSettings() {
        delegate?.statusMenuVMDelegateShouldShowSettings(self, toPage: 1)
    }

    // MARK: Helper Methods

    private func loadMockData() -> Bool {
        /*
            To load mock data, fill in `/Supporting Files/mockdata.json` with any entries you'd like to see in the menu bar.
            JSON Structure:
            [
                {
                    "repoName": "GitHub Test Repo",
                    "name": "Test Issue 1",
                    "type": 1,
                    "source": "GitHub",
                    "labels": [
                        {
                            "title": "Test Label",
                            "color": "FFFFFF"
                        }
                    ]
                },
                { // ... }
            ]
        */
        if let path = Bundle.main.path(forResource: "mockdata", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decoder = JSONDecoder()
                let tickets = try decoder.decode([Ticket].self, from: data)

                var ticketsByRepo: [Repository: [Ticket]] = [:]
                tickets.forEach {
                    let repo = Repository(name: $0.repoName, source: $0.source, url: "", username: "test", owner: "Test Repo")
                    if ticketsByRepo[repo] != nil {
                        ticketsByRepo[repo]!.append($0)
                    } else {
                        ticketsByRepo[repo] = [$0]
                    }
                }

                // This wait is here to make sure all the UI has loaded before we add the issues, this is bad and I feel bad.
                DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(3)) {
                    self.ticketsByRepo = ticketsByRepo
                    self.delegate?.statusMenuVMDelegate(self, updatedRepos: Array(RepoOwner.sortRepos(ticketsByRepo.keys.map { $0 })))
                }
                return true
            } catch {
                LogManager.shared.log("Error loading mock data: \(error)")
            }
        }
        return false
    }

    private func scheduleNotifications(forAddedTickets addedTickets: [Ticket]) {
        guard Defaults[.enableNotifications] else {
            // user doesn't have notifications enabled, so don't fire any.
            return
        }

        for ticket in addedTickets {
            let notification = NSUserNotification()
            notification.identifier = "\(ticket.url)"
            notification.title = ticket.repoName
            notification.subtitle = "New \(ticket.type.description)"
            notification.informativeText = ticket.name
            notification.soundName = NSUserNotificationDefaultSoundName
            NSUserNotificationCenter.default.deliver(notification)
        }
    }

    private func startTicketRefreshTimer(interval: Double = StatusMenuViewModel.defaultRefreshInterval) {
        refreshTimer?.invalidate()
        refreshTimer = Timer.scheduledTimer(timeInterval: interval, target: self, selector: #selector(getTickets), userInfo: nil, repeats: true)
    }

    private func getNetworkErrorMenu(_ error: NetworkError) -> NSMenu {
        let title: String!
        let message: String!
        var destination: ReminderDestination?

        switch error.statusCode {
        case -100:
            title = "🚫 Account Error"
            message = "No tokens found, add one from Settings."
            destination = .accounts
        case 503:
            title = "🚫 Unable to connect"
            message = "We're having trouble reaching the network.\nAttempting to reconnect..."
            destination = .reconnect
        case 401:
            title = "🚫 Account Error"
            message = "One of your tokens is no longer valid.\nClick here to fix it."
            destination = .accounts
        default:
            title = "🚫 Network Error"
            message = "\(error.message)"
        }

        let menu = NSMenu()
        menu.addItem(ReminderItem(title: title, subtitle: message, destination: destination))
        menu.addItem(NSMenuItem.separator())
        menu.addItem(self.settingsMenuItem)
        menu.addItem(quitMenuItem)

        print("==== checking here")

        UpdateModel.shared.checkForBatsignal(
            onSuccess: { batsignal in
                if let batsignal = batsignal, !batsignal.title.isEmpty {
                    menu.insertItem(ReminderItem(title: batsignal.title, subtitle: batsignal.message, destination: .url(batsignal.url)), at: 0)
                    menu.insertItem(NSMenuItem.separator(), at: 1)
                }
            },
            onFailure: { error in
                debugPrint("Batsignal check failed: \(error)")
            }
        )

        return menu
    }

    private func updateStoredInfo() {
        var issuesByRepo = [Repository: [Ticket]]()
        var prsByRepo = [Repository: [Ticket]]()
        var issueCount = 0
        var prCount = 0

        for (repo, tickets) in ticketsByRepo {
            guard !Defaults[.ignoredRepos].contains(repo.name) else {
                continue
            }

            tickets.forEach { ticket in
                switch ticket.type {
                case .issue:
                    issueCount += 1
                    issuesByRepo.insert(ticket: ticket, forKey: repo)
                case .authored, .pullRequest, .reviewRequest:
                    prCount += 1
                    prsByRepo.insert(ticket: ticket, forKey: repo)
                }
            }
        }

        delegate?.statusMenuVMDelegate(self, updatedMenu: convertTicketsToMenu(), issueCount: issueCount, prCount: prCount)
    }

    private func calculateTicketsDiff(newTicketsByRepo: [Repository: [Ticket]]) -> ([Ticket], [Ticket]) {
        var added = [Ticket]()
        var removed = [Ticket]()

        let oldTickets = ticketsByRepo
            .filter { !Defaults[.ignoredRepos].contains($0.key.name) }
            .flatMap { $0.value }

        let newTickets = newTicketsByRepo
            .filter { !Defaults[.ignoredRepos].contains($0.key.name) }
            .flatMap { $0.value }

        for oldTicket in oldTickets where !newTickets.contains(where: { $0.url == oldTicket.url }) {
            removed.append(oldTicket)
        }

        for newTicket in newTickets where !oldTickets.contains(where: { $0.url == newTicket.url }) {
            added.append(newTicket)
        }

        return (added, removed)
    }

    private func convertTicketsToMenu() -> NSMenu {
        let menu = NSMenu()

        UpdateModel.shared.checkForBatsignal(
            onSuccess: { batsignal in
                if let batsignal = batsignal, !batsignal.title.isEmpty {
                    DispatchQueue.main.async {
                        menu.insertItem(ReminderItem(title: batsignal.title, subtitle: batsignal.message, destination: .url(batsignal.url)), at: 0)
                    }
                }
            },
            onFailure: { error in
                debugPrint("Batsignal check failed: \(error)")
            }
        )

        guard !ticketsByRepo.isEmpty else {
            menu.addItem(ReminderItem(title: "Quests Complete 🎉", subtitle: "More Issues and PRs will appear here\nwhen they're assigned to you."))
            menu.addItem(NSMenuItem.separator())
            menu.addItem(settingsMenuItem)
            menu.addItem(quitMenuItem)
            return menu
        }

        let ticketLength = getTicketLength(ticketsByRepo)
        var totalTicketCount = 0

        let sortedTickets = ticketsByRepo.sorted { lhs, rhs in
            let lname = lhs.key.name.lowercased()
            let rname = rhs.key.name.lowercased()

            if lname == rname {
                return lhs.value.mostRecentlyUpdated() > rhs.value.mostRecentlyUpdated()

            }
            return lname < rname
        }

        for (repo, tickets) in sortedTickets {
            totalTicketCount += tickets.count
            guard !Defaults[.ignoredRepos].contains(repo.name) else {
                continue
            }

            // First add repo title with link
            menu.addItem(NSMenuItem.separator())
            let repoItem = NSMenuItem(title: "", action: #selector(repoItemPressed(_:)), keyEquivalent: "")
            repoItem.attributedTitle = NSAttributedString(string: repo.name, attributes: [
                NSAttributedStringKey.foregroundColor: NSColor.lightGray
            ])
            repoItem.target = self
            repoItem.representedObject = repo
            menu.addItem(repoItem)

            // Sort our tickets based first on type, then date created
            let sortedTickets = tickets.sorted {
                if $0.type == $1.type {
                    return $0.updatedAt > $1.updatedAt
                }

                return $0.type.rawValue > $1.type.rawValue
            }

            let nestedTickets = sortedTickets.dropFirst(ticketNestThreshold)
            for ticket in sortedTickets.prefix(ticketNestThreshold) {
                menu.addItem(TicketMenuItem(from: ticket, length: ticketLength))
            }

            guard !nestedTickets.isEmpty else {
                continue
            }

            let nestedMenuItem = NSMenuItem(title: makeNestedTitle(nestAll: ticketNestThreshold == 0, ticketCount: sortedTickets.count), action: nil, keyEquivalent: "")
            let nestedMenu = NSMenu()

            menu.addItem(nestedMenuItem)
            menu.setSubmenu(nestedMenu, for: nestedMenuItem)

            for ticket in nestedTickets {
                nestedMenu.addItem(TicketMenuItem(from: ticket, length: ticketLength))
            }
        }

        if totalTicketCount <= 5 {
            menu.addItem(NSMenuItem.separator())
            menu.addItem(ReminderItem(subtitle: "More Issues and PRs will appear here\nwhen they're assigned to you."))
        }

        menu.addItem(NSMenuItem.separator())

        let numErrors = NetworkCoordinator.shared.tokenErrors.values.reduce(0) { $0 + $1.count }
        if numErrors != 0 {
            menu.addItem(NSMenuItem.separator())
            menu.addItem(NSMenuItem(title: "Account error, learn more in the Accounts tab of Settings", action: nil, keyEquivalent: ""))
        }
        menu.addItem(settingsMenuItem)
        menu.addItem(quitMenuItem)
        return menu
    }

    private func getTicketLength(_ ticketsByRepo: [Repository: [Ticket]]) -> Int {
        // Before laying out tickets, need to figure out roughly how long each ticket title & label count is
        var sumChars: Double = 0
        var sumCharsSquared: Double = 0
        var count: Double = 0

        for (_, tickets) in ticketsByRepo {
            for ticket in tickets {
                let charCount = Double(ticket.name.count)
                sumChars += charCount
                sumCharsSquared += pow(charCount, 2)
                count += 1
            }
        }

        let mean = sumChars / count
        let stdDev = sqrt((sumCharsSquared / count) - (mean * mean))
        return Int(mean + 2 * stdDev)
    }

    private func makeNestedTitle(nestAll: Bool, ticketCount: Int) -> String {
        if nestAll {
            return "\(ticketCount) Ticket\(ticketCount != 1 ? "s" : "")"
        }

        return "\(ticketCount - ticketNestThreshold) More"
    }
}
