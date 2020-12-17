//
//  StatusMenuController.swift
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
import SwiftyUserDefaults
import Valet

class StatusMenuController: NSObject {
    private let viewModel = StatusMenuViewModel()

    @IBOutlet private var statusMenu: NSMenu!

    private let statusBarItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
    private var statusBarView: StatusBarView!
    private var currentMenu: NSMenu?

    private var introWindow: AddTokenWindowController!
    private var settingsWindow: SettingsWindowController!
    private var newVersionWindow: NewVersionWindowController!

    override func awakeFromNib() {
        super.awakeFromNib()

        viewModel.delegate = self

        statusBarItem.menu = statusMenu
        let statusBarIcon = NSImage(named: NSImage.Name("icon_status-bar"))
        statusBarIcon?.isTemplate = true
        statusBarItem.button?.image = statusBarIcon
        addStatusMenuView()
        statusMenu.addItem(viewModel.settingsMenuItem)
        statusMenu.addItem(viewModel.quitMenuItem)

        introWindow = AddTokenWindowController(windowNibName: NSNib.Name("AddTokenWindowController"))
        introWindow.delegate = self

        settingsWindow = SettingsWindowController(windowNibName: NSNib.Name("SettingsWindowController"))
        settingsWindow.delegate = self

        newVersionWindow = NewVersionWindowController(windowNibName: NSNib.Name("NewVersionWindowController"))

        // Check if they've got a pre-1.0 auth token and migrate it to the new system
        migrateLegacyToken()

        // If they've never seen the intro screen before and haven't entered a token, show them it.
        if Defaults[.tokens].isEmpty {
            showStartMenuBar()
            introWindow.isFirstUse = true
            introWindow.showAndFocus(sender: self)
        } else {
            checkForUpdates(inBackground: true)
        }
    }

    // MARK: Helper Functions

    private func migrateLegacyToken() {
        guard let legacyToken = try? Valet.shared.string(forKey: Valet.tokenKey),
                let username = Defaults[.username] else {
            // No legacy token, carry on
            return
        }

        // If they've already got a username just store it, otherwise need to double check the token is valid and get back the correct username
        if username.isEmpty {
            NetworkCoordinator.shared.authenticateUser(
                source: .github,
                token: legacyToken,
                jiraAuthInfo: nil,
                onSuccess: {
                    try? Valet.shared.removeObject(forKey: Valet.tokenKey)
                    Defaults[.username] = nil
                }, onFailure: { error in print(error) }
            )
        } else {
            LogManager.shared.log("Migrating legacy token for user \(username)...")

            let newToken = Token(created: Date(), source: .github, username: username, domain: nil)
            DefaultsKeys.add(token: newToken)
            try? Valet.shared.setString(legacyToken, forKey: "QuestsToken-\(Source.github.rawValue)-\(username)")

            // Finally clear the old token/username so we don't need to do this again
            try? Valet.shared.removeObject(forKey: Valet.tokenKey)
            Defaults[.username] = nil
        }
    }

    private func showStartMenuBar() {
        let emptyMenu = NSMenu()
        emptyMenu.addItem(NSMenuItem(title: "Auth required...", action: nil, keyEquivalent: ""))
        emptyMenu.addItem(viewModel.settingsMenuItem)
        emptyMenu.addItem(viewModel.quitMenuItem)
        statusBarItem.menu = emptyMenu
        statusBarItem.length = 25
        statusBarItem.button?.image = NSImage(named: NSImage.Name(rawValue: "icon_status-bar"))
    }

    private func addStatusMenuView() {
        if let button = statusBarItem.button {
            button.subviews.removeAll()
            let defaultWidth: CGFloat = 20
            statusBarItem.length = defaultWidth
            let frame = NSRect(x: 0, y: 0, width: defaultWidth, height: 22)
            statusBarView = StatusBarView(frame: frame)
            statusBarView.parent = button
            button.addSubview(statusBarView)
        }
    }

    private func checkForUpdates(inBackground: Bool = false) {
        if UpdateModel.shared.appSource() == .appStore {
            return
        }

        // Assume a non-background check for updates as a forced attempt, and must check for updates regardless of the 24h rule.
        if inBackground {
            if let lastCheckDate = Defaults[.updateLastChecked], Date().hours(from: lastCheckDate) < 24 {
                return
            }
        }

        UpdateModel.shared.checkForUpdates(onSuccess: { versionInfo in
            guard let info = versionInfo else {
                if !inBackground {
                    self.settingsWindow.showAlert(message: "No new version found. You're all caught up!")
                }
                return
            }

            self.newVersionWindow.versionInfo = info
            self.newVersionWindow.showAndFocus(sender: self)
        }, onFailure: { error in
            self.settingsWindow.showAlert(message: error.localizedDescription)
        })
    }
}

extension StatusMenuController: StatusMenuVMDelegate {
    func statusMenuVMDelegate(_ statusMenuViewModel: StatusMenuViewModel, showErrorMenu menu: NSMenu) {
        guard statusBarView != nil else { return }

        statusBarItem.menu = menu
        let statusBarIcon = NSImage(named: NSImage.Name("icon_status-bar"))
        statusBarIcon?.isTemplate = true
        statusBarItem.button?.image = statusBarIcon
        statusBarItem.length = statusBarView.containerView.frame.width
        statusBarView.containerView.isHidden = true
        statusBarItem.button?.layoutSubtreeIfNeeded()
    }

    func statusMenuVMDelegate(_ statusMenuViewModel: StatusMenuViewModel, updatedRepos: [RepoOwner]) {
        guard settingsWindow != nil else { return }
        settingsWindow.showLoading(false)
        settingsWindow.repos = updatedRepos
    }

    func statusMenuVMDelegate(_ statusMenuViewModel: StatusMenuViewModel, updatedMenu menu: NSMenu, issueCount: Int, prCount: Int) {
        statusBarItem.menu = menu
        statusBarItem.button?.image = nil
        statusBarView.updateLabels(issueCount: issueCount, prCount: prCount)
        statusBarItem.length = statusBarView.containerView.frame.width
        statusBarItem.button?.layoutSubtreeIfNeeded()
    }

    func statusMenuVMDelegateShouldShowSettings(_ statusMenuViewModel: StatusMenuViewModel, toPage page: Int = 0) {
        // calling .isVisible here will cause the window to appear if it hasn't been loaded yet,
        // so we'll need to close them later if they shouldn't be showing
        let introOpen = introWindow.window?.isVisible ?? false
        let settingsOpen = settingsWindow.window?.isVisible ?? false

        if Defaults[.tokens].isEmpty {
            settingsWindow.close()
            introWindow.isFirstUse = true
            if introOpen {
                introWindow.focus(sender: self)
            } else {
                introWindow.showAndFocus(sender: self)
            }
            introWindow.isFirstUse = true
            return
        }

        introWindow.close()
        if settingsOpen {
            settingsWindow.focus(sender: self)
        } else {
            settingsWindow.showAndUpdate(sender: self)
        }

        settingsWindow.setToActive(page: page)

        checkForUpdates(inBackground: true)
    }
}

extension StatusMenuController: AddTokenDelegate {
     func addTokenWindowControllerDidEnterToken(_ addTokenWindowController: AddTokenWindowController) {
        statusBarItem.button?.image = NSImage(named: NSImage.Name("icon_status-bar"))
        addTokenWindowController.close()
        addStatusMenuView()
        viewModel.startRetrievingTickets()
        settingsWindow?.showAndUpdate(sender: self)

        checkForUpdates(inBackground: true)
    }
}

extension StatusMenuController: SettingsWindowDelegate {
    func settingsWindowShouldCheckUpdates(_ settingsWindowController: SettingsWindowController) {
        checkForUpdates()
    }

    func settingsWindowOptionChanged(_ settingsWindowController: SettingsWindowController) {
        // Trigger a reload when a setting gets changed
        viewModel.startRetrievingTickets()
    }

    func settingsWindowDidInvalidateToken(_ settingsWindowController: SettingsWindowController) {
        viewModel.clearTickets()
        viewModel.startRetrievingTickets()
    }
}
