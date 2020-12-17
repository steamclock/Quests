//
//  AdvancedSettingsWindowController.swift
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

class AdvancedSettingsWindowController: NSWindowController {
    @IBOutlet var ignoreDoneToggle: NSButton!
    @IBOutlet var ignoreStatusField: NSTextField!

    override func windowDidLoad() {
        super.windowDidLoad()

        ignoreDoneToggle.state = Defaults[.ignoreJIRADone] ? NSControl.StateValue.on : NSControl.StateValue.off
        ignoreStatusField.delegate = self
        ignoreStatusField.stringValue = Defaults[.ignoredJIRAStatuses].reduce("") { $0 + "\($1)," }
    }

    @IBAction func ignoreDoneToggled(_ sender: NSButton) {
        let toggledOn = sender.state == NSControl.StateValue.on ? true : false
        Defaults[.ignoreJIRADone] = toggledOn
        AnalyticsModel.shared.settingToggled(.ignoreJIRADone, on: toggledOn)
    }

    @IBAction func donePressed(_ sender: NSButton) {
        NSApplication.shared.stopModal()
    }
}

extension AdvancedSettingsWindowController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        let statusTokens = ignoreStatusField.stringValue.split(separator: ",").map { String($0).uppercased() }
        Defaults[.ignoredJIRAStatuses] = statusTokens
    }
}
