//
//  SettingsWindowController.swift
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
import ServiceManagement
import SnapKit
import SwiftyUserDefaults

protocol SettingsWindowDelegate: AnyObject {
    func settingsWindowOptionChanged(_ settingsWindowController: SettingsWindowController)
    func settingsWindowShouldCheckUpdates(_ settingsWindowController: SettingsWindowController)
    func settingsWindowDidInvalidateToken(_ settingsWindowController: SettingsWindowController)
}

class SettingsWindowController: NSWindowController, NSWindowDelegate {
    @IBOutlet private var tabView: NSTabView!

    // MARK: General Window
    @IBOutlet private var launchAtLoginButton: NSButton!
    @IBOutlet private var enableNotificationsButton: NSButton!
    @IBOutlet private var showLabelsButton: NSButton!
    @IBOutlet private var onlyShowPRsButton: NSButton!
    @IBOutlet private var showAuthoredButton: NSButton!
    @IBOutlet private var alwaysShowSubmenusButton: NSButton!
    @IBOutlet private var sendSystemInfoButton: NSButton!
    @IBOutlet private var emptyCollectionLabel: NSTextField!
    @IBOutlet private var loadingSpinner: NSProgressIndicator?
    @IBOutlet private var advancedOptionsButton: NSButton!

    // MARK: Accounts Window
    @IBOutlet private var accountsTableView: NSTableView!
    @IBOutlet private var addRemoveControl: NSSegmentedCell!

    private var addTokenWindow: AddTokenWindowController?
    private var tokens = [Token]()

    // MARK: About Window
    @IBOutlet private var repoCollectionView: NSCollectionView?
    @IBOutlet private var versionLabel: NSTextField!
    @IBOutlet private var checkForUpdatesButton: NSButton!
    @IBOutlet private var lastCheckedLabel: NSTextField!

    weak var delegate: SettingsWindowDelegate?
    var repos = [RepoOwner]() {
        didSet {
            repoCollectionView?.reloadData()

            if !repos.isEmpty {
                loadingSpinner?.stopAnimation(self)
            }

            let totalHeight = itemSize.height + largeHeaderSize.height + headerSize.height * CGFloat(repos.count - 1) + itemSize.height * CGFloat(repos.flatMap { $0.repos }.count)
            repoCollectionView?.snp.updateConstraints { make in make.height.equalTo(totalHeight) }
        }
    }
    private var repoCollectionItems = [String: RepoCheckCollectionViewItem]()

    private let itemSize = CGSize(width: 220, height: 20)
    private let largeHeaderSize = CGSize(width: 220, height: 37)
    private let headerSize = CGSize(width: 220, height: 29)

    override func windowDidLoad() {
        super.windowDidLoad()

        NSApp.activate(ignoringOtherApps: true)

        let onState = NSControl.StateValue.on
        let offState = NSControl.StateValue.off

        launchAtLoginButton.state = Defaults[.launchAtLogin] ? onState : offState
        enableNotificationsButton.state = Defaults[.enableNotifications] ? onState : offState
        alwaysShowSubmenusButton.state = Defaults[.alwaysShowSubmenus] ? onState : offState
        onlyShowPRsButton.state = Defaults[.onlyShowPRs] ? onState : offState
        showAuthoredButton.state = !Defaults[.hideAuthored] ? onState: offState
        showLabelsButton.state = !Defaults[.dontShowLabels] ? onState : offState
        sendSystemInfoButton.state = Defaults[.sendSystemInfo] ? onState : offState

        repoCollectionView?.delegate = self
        repoCollectionView?.dataSource = self

        let flowLayout = NSCollectionViewFlowLayout()
        flowLayout.itemSize = itemSize
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 0
        repoCollectionView?.collectionViewLayout = flowLayout
        repoCollectionView?.enclosingScrollView?.borderType = .bezelBorder
        repoCollectionView?.enclosingScrollView?.verticalScrollElasticity = .none

        // Figure out how tall the collection view needs to be, assuming there's repos to show. It will contain:
        // 1. The Show All Cell: 20
        // 2. The extra large header with separator and owner title: 40
        // 3. One header for each owner: 20
        // 4. One cell per repo: 20
        let totalHeight = itemSize.height + largeHeaderSize.height + headerSize.height * CGFloat(repos.count - 1) + itemSize.height * CGFloat(repos.flatMap { $0.repos }.count)
        repoCollectionView?.snp.makeConstraints { make in make.height.equalTo(totalHeight) }

        if UpdateModel.shared.appSource() == .appStore {
            advancedOptionsButton.removeFromSuperview()
        }

        // MARK: Accounts Page Settings

        accountsTableView.dataSource = self
        accountsTableView.delegate = self
        accountsTableView.action = #selector(accountsTableClicked)

        tokens = Defaults[.tokens]
        accountsTableView.reloadData()

        addTokenWindow = AddTokenWindowController(windowNibName: NSNib.Name("AddTokenWindowController"))
        addTokenWindow?.delegate = self

        // MARK: About Page Settings

        versionLabel.setToLabel()
        versionLabel.stringValue = "v" + Bundle.versionString

        updateLastCheckedLabel()

        showLoading(true)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(startedGetTickets),
            name: .startedGetTickets,
            object: nil
        )
    }

    func showAndUpdate(sender: Any?) {
        if let addWindow = addTokenWindow?.window {
            window?.endSheet(addWindow)
        }

        showAndFocus(sender: self)

        tokens = Defaults[.tokens]
        accountsTableView.reloadData()

        if !repos.isEmpty {
            showLoading(false)
        }
    }

    override func keyDown(with event: NSEvent) {
        // Close the window if cmd+w is pressed
        if event.keyCode == 13 && event.modifierFlags.intersection(.deviceIndependentFlagsMask) == [.command] {
            close()
            return
        }
        super.keyDown(with: event)
    }

    func showLoading(_ isLoading: Bool) {
        if isLoading {
            loadingSpinner?.startAnimation(self)
        } else {
            loadingSpinner?.stopAnimation(self)
        }
    }

    func setToActive(page: Int) {
        guard page <= tabView.numberOfTabViewItems - 1 else {
            debugPrint("⚠️ SettingsWindowController tried to set a page active that doesn't exist. Something's gone wrong.")
            return
        }

        tabView.selectTabViewItem(at: page)
    }

    // MARK: - Actions

    @IBAction func advancedPressed(_ sender: Any) {
        let advancedWindow = AdvancedSettingsWindowController(windowNibName: NSNib.Name("AdvancedSettingsWindowController"))

        if let window = advancedWindow.window {
            NSApplication.shared.runModal(for: window)

            window.close()
        }
    }

    @IBAction func checkForUpdates(_ sender: NSButton) {
        delegate?.settingsWindowShouldCheckUpdates(self)
        updateLastCheckedLabel()
    }

    @IBAction func sendFeedbackPressed(_ sender: NSButton) {
        let service = NetworkCoordinator.shared.contactSupportService()
        service?.perform(withItems: [])
    }

    @IBAction func sendLogsPressed(_ sender: Any) {
        let versionString = Bundle.versionString
        let sharingService = NSSharingService(named: .composeEmail)
        sharingService?.recipients = ["support@steamclock.com"]
        sharingService?.subject = "Quests v\(versionString) Debug Logs"

        if let logs = LogManager.shared.getLogFile() {
            sharingService?.perform(withItems: [logs])
        } else {
            sharingService?.perform(withItems: [])
        }
    }

    @IBAction func launchAtLoginPressed(_ sender: NSButton) {
        let toggledOn = sender.state == NSControl.StateValue.on ? true : false
        Defaults[.launchAtLogin] = toggledOn
        SMLoginItemSetEnabled("com.steamclock.QuestsLauncher" as CFString, toggledOn)
        AnalyticsModel.shared.settingToggled(.launchAtLogin, on: toggledOn)
    }

    @IBAction func enableNotificationsPressed(_ sender: NSButton) {
        let toggledOn = sender.state == NSControl.StateValue.on ? true : false
        Defaults[.enableNotifications] = toggledOn
        delegate?.settingsWindowOptionChanged(self)
        AnalyticsModel.shared.settingToggled(.notifications, on: toggledOn)
    }

    @IBAction func alwaysShowSubmenusPressed(_ sender: NSButton) {
        let toggledOn = sender.state == NSControl.StateValue.on ? true : false
        Defaults[.alwaysShowSubmenus] = toggledOn
        delegate?.settingsWindowOptionChanged(self)
        AnalyticsModel.shared.settingToggled(.alwaysSubmenus, on: toggledOn)
    }

    @IBAction func onlyShowPRsPressed(_ sender: NSButton) {
        let toggledOn = sender.state == NSControl.StateValue.on ? true : false
        Defaults[.onlyShowPRs] = toggledOn
        delegate?.settingsWindowOptionChanged(self)
        AnalyticsModel.shared.settingToggled(.onlyPRs, on: toggledOn)
    }

    @IBAction func showAuthoredPressed(_ sender: NSButton) {
        let toggledOn = sender.state == NSControl.StateValue.on ? false : true
        Defaults[.hideAuthored] = toggledOn
        delegate?.settingsWindowOptionChanged(self)
        AnalyticsModel.shared.settingToggled(.hideAuthored, on: toggledOn)
    }

    @IBAction func showLabelsPressed(_ sender: NSButton) {
        let toggledOn = sender.state == NSControl.StateValue.on ? false : true
        Defaults[.dontShowLabels] = toggledOn
        delegate?.settingsWindowOptionChanged(self)
        AnalyticsModel.shared.settingToggled(.hideLabels, on: toggledOn)
    }

    @IBAction func segmentButtonClicked(_ sender: NSSegmentedControl) {
        switch sender.selectedSegment {
        case 0: addPressed()
        case 1: removePressed()
        default: return
        }
    }

    @IBAction func sendSystemInfoPressed(_ sender: NSButton) {
        let toggledOn = sender.state == NSControl.StateValue.on ? true : false
        Defaults[.sendSystemInfo] = toggledOn
        AnalyticsModel.shared.settingToggled(.systemInfo, on: toggledOn)
    }

    @IBAction func privacyPolicyClicked(_ sender: Any) {
        NSWorkspace.shared.open(NetworkCoordinator.privacyPolicyURL)
    }

    @objc private func startedGetTickets() {
        if repos.isEmpty {
            loadingSpinner?.startAnimation(self)
        } else {
            loadingSpinner?.stopAnimation(self)
        }
    }

    @objc private func accountsTableClicked() {
        let row = accountsTableView.clickedRow
        let col = accountsTableView.clickedColumn

        // We're only interested in clicks in the error column, for items that have an error
        // This is in a kind of weird order since Swift will stop checking conditions as soon as 1 fails and we want to fail early.
        guard col == 2,
            let item = tokens[safe: row],
            let error = NetworkCoordinator.shared.tokenErrors[item]?.first else { return }

        showAlert(message: error.message)
    }

    // MARK: Helper Functions

    private func addPressed() {
        guard let addWindow = addTokenWindow else { return }
        addWindow.reset()
        addWindow.isFirstUse = false
        addWindow.showWindow(self)
    }

    private func removePressed() {
        let selectedRow = accountsTableView.selectedRow
        guard tokens[safe: selectedRow] != nil else { return }

        let removedToken = tokens.remove(at: selectedRow)
        DefaultsKeys.remove(token: removedToken)
        delegate?.settingsWindowDidInvalidateToken(self)

        accountsTableView.reloadData()
        repoCollectionView?.reloadData()
    }

    private func updateLastCheckedLabel() {
        guard UpdateModel.shared.appSource() != .appStore else {
            lastCheckedLabel.isHidden = true
            lastCheckedLabel.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
            checkForUpdatesButton.isHidden = true
            checkForUpdatesButton.snp.remakeConstraints { make in
                make.height.equalTo(0)
            }
            return
        }

        lastCheckedLabel.stringValue = "Last Checked "
        if let lastCheckDate = Defaults[.updateLastChecked] {
            let formatter = DateFormatter()
            formatter.dateFormat = "EEEE, MMM d HH:mm"
            lastCheckedLabel.stringValue += formatter.string(from: lastCheckDate)
        } else {
            lastCheckedLabel.stringValue += "Never"
        }
    }

    private func setEmptyCollectionLabel(hidden: Bool) {
        emptyCollectionLabel.isHidden = hidden
    }
}

extension SettingsWindowController: NSCollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: NSCollectionView, layout collectionViewLayout: NSCollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> NSSize {
        switch section {
        case 0: return NSSize(width: 220, height: 0)
        case 1: return largeHeaderSize
        default: return headerSize
        }
    }

    func collectionView(_ collectionView: NSCollectionView, viewForSupplementaryElementOfKind kind: NSCollectionView.SupplementaryElementKind, at indexPath: IndexPath) -> NSView {
        if kind == .sectionHeader {
            var view = NSView()
            switch indexPath.section {
            case 0: view = NSView()
            case 1:
                if let newView = collectionView.makeSupplementaryView(
                        ofKind: .sectionHeader,
                        withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionSpacerView"),
                        for: indexPath) as? CollectionSpacerView {
                    newView.label.stringValue = repos[indexPath.section - 1].name
                    newView.setSpacer(hidden: false)
                    view = newView
                }
            default:
                if let newView = collectionView.makeSupplementaryView(
                        ofKind: .sectionHeader,
                        withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "CollectionSpacerView"),
                        for: indexPath) as? CollectionSpacerView {
                    newView.setSpacer(hidden: true)
                    newView.label.stringValue = repos[indexPath.section - 1].name
                    view = newView
                }
            }

            return view
        }

        return NSView()
    }
}

extension SettingsWindowController: NSCollectionViewDataSource, NSCollectionViewDelegate {
    func numberOfSections(in collectionView: NSCollectionView) -> Int {
        repos.isEmpty ? 1 : repos.count + 1
    }

    func collectionView(_ collectionView: NSCollectionView, numberOfItemsInSection section: Int) -> Int {
        if repos.isEmpty {
            setEmptyCollectionLabel(hidden: false)
            return 0
        }

        setEmptyCollectionLabel(hidden: true)
        switch section {
        case 0: return 1
        default: return repos[section - 1].repos.count
        }
    }

    func collectionView(_ collectionView: NSCollectionView, itemForRepresentedObjectAt indexPath: IndexPath) -> NSCollectionViewItem {
        let item = collectionView.makeItem(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: "RepoCheckCollectionViewItem"), for: indexPath)
        guard let collectionViewItem = item as? RepoCheckCollectionViewItem, let row = indexPath.last else { return item }

        switch indexPath.section {
        case 0:
            collectionViewItem.repo = "Show All"
            collectionViewItem.checkButton.state = Defaults[.ignoredRepos].isEmpty ? .on : .off
            collectionViewItem.showAllDelegate = self
        default:
            let repoName = repos[indexPath.section - 1].repos[row].name
            collectionViewItem.repo = repoName
            collectionViewItem.showAllDelegate = nil
            collectionViewItem.checkButton.state = Defaults[.ignoredRepos].contains(repoName) ? .off : .on
            repoCollectionItems["\(indexPath.section)\(row)"] = collectionViewItem
        }
        return collectionViewItem
    }
}

extension SettingsWindowController: RepoCheckCollectionViewItemDelegate {
    func repoCheckCollectionViewItem(_ repoCheckCollectionViewItem: RepoCheckCollectionViewItem, didToggleShowAll: Bool) {
        for item in repoCollectionItems {
            item.value.checkButton.state = didToggleShowAll ? .on : .off
            item.value.buttonChecked(item.value.checkButton)
        }
    }
}

extension SettingsWindowController: NSTableViewDataSource, NSTableViewDelegate {
    private enum CellIdentifiers {
        static let source = "SourceCell"
        static let username = "UsernameCell"
        static let error = "ErrorCell"
    }

    func numberOfRows(in tableView: NSTableView) -> Int {
        tokens.count
    }

    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let item = tokens[safe: row] else { return nil }

        var cellIdentifier = ""
        var text = ""
        var image: NSImage?

        switch tableColumn {
        case tableView.tableColumns[0]:
            cellIdentifier = CellIdentifiers.source
            image = item.source.image
        case tableView.tableColumns[1]:
            cellIdentifier = CellIdentifiers.username
            var username = item.username
            if let domain = item.domain {
                username = "\(domain)/" + username
            }
            text = username
        case tableView.tableColumns[2]:
            cellIdentifier = CellIdentifiers.error
            let hasError = !(NetworkCoordinator.shared.tokenErrors[item]?.isEmpty ?? true)
            image = hasError ? NSImage(named: NSImage.Name(rawValue: "warning")) : nil
        default: return nil
        }

        if let cell = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier(rawValue: cellIdentifier), owner: nil) as? NSTableCellView {
            cell.imageView?.image = image
            cell.textField?.stringValue = text
            return cell
        }
        return nil
    }
}

extension SettingsWindowController: AddTokenDelegate {
    func addTokenWindowControllerDidEnterToken(_ addTokenWindowController: AddTokenWindowController) {
        tokens = Defaults[.tokens]
        accountsTableView.reloadData()
        addTokenWindowController.close()

        delegate?.settingsWindowOptionChanged(self)
    }
}
