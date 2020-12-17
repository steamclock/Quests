//
//  AddTokenSourceViewController.swift
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

protocol AddTokenSourceDelegate: AnyObject {
    func addTokenSourceSelected(_ addTokenSourceViewController: AddTokenSourceViewController, source: Source)
}

class AddTokenSourceViewController: NSViewController {
    @IBOutlet private var titleLabel: NSTextField!
    @IBOutlet private var subtitleLabel: NSTextField!
    @IBOutlet private var reminderLabel: NSTextField!
    @IBOutlet private var jiraButton: NSButton!

    weak var delegate: AddTokenSourceDelegate?

    var isFirstUse: Bool = false {
        didSet {
            titleLabel.stringValue = isFirstUse ? "Welcome to Quests!" : "Add an Account"
            subtitleLabel.stringValue = "Choose a service to connect."
            reminderLabel.stringValue = isFirstUse ? "You can always add more later." : ""
        }
    }

    override func viewWillAppear() {
        super.viewWillAppear()

        if UpdateModel.shared.appSource() == .appStore {
            jiraButton.removeFromSuperview()
        }
    }

    @IBAction func githubSelected(_ sender: Any) {
        delegate?.addTokenSourceSelected(self, source: .github)
    }

    @IBAction func gitlabSelected(_ sender: Any) {
        delegate?.addTokenSourceSelected(self, source: .gitlab)
    }

    @IBAction func jiraSelected(_ sender: Any) {
        delegate?.addTokenSourceSelected(self, source: .jira)
    }
}
