//
//  AddTokenAuthViewController.swift
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

protocol AddTokenAuthDelegate: AnyObject {
    func addTokenAuthDidCancel(_ addTokenAuthViewController: AddTokenAuthViewController)
    func addTokenAuthDidComplete(_ addTokenAuthViewController: AddTokenAuthViewController)
    func addTokenAuthDidError(_  addTokenAuthViewController: AddTokenAuthViewController, error: String)
    func addTokenAuthDidFailToken(_  addTokenAuthViewController: AddTokenAuthViewController, error: String, token: Token, key: String)
}

class AddTokenAuthViewController: NSViewController {
    @IBOutlet private var sourceImage: NSImageView!
    @IBOutlet private var reminderLabel: NSTextField!
    @IBOutlet private var reminderLabelSecondary: NSTextField!
    @IBOutlet private var visitSourceButton: NSButton!
    @IBOutlet private var userDomainFields: NSStackView!
    @IBOutlet private var userField: PastableTextField!
    @IBOutlet private var domainField: PastableTextField!
    @IBOutlet private var tokenField: PastableTextField!
    @IBOutlet private var goButton: NSButton!

    var source: Source?
    weak var delegate: AddTokenAuthDelegate?

    private let authReminder = "You'll need to generate a new personal access token"

    override func viewWillAppear() {
        super.viewWillAppear()

        tokenField.delegate = self
        goButton.isEnabled = false

        guard let source = source else { return }
        sourceImage.image = source.largeImage

        visitSourceButton.title = "Visit \(source.title) to Generate"
        reminderLabel.stringValue = authReminder
        switch source {
        case .jira:
            reminderLabel.stringValue += ","
            reminderLabelSecondary.stringValue = "and provide your Atlassian username and project domain."
        case .github:
            reminderLabelSecondary.stringValue = "Make sure you leave repo access checked."
        case .gitlab:
            reminderLabelSecondary.stringValue = "Make sure you check api access when selecting token scope"
        }

        userDomainFields.isHidden = source != .jira
    }

    @IBAction func startOverPressed(_ sender: Any) {
        reset()
        delegate?.addTokenAuthDidCancel(self)
    }

    @IBAction func visitSourcePressed(_ sender: Any) {
        guard let url = source?.tokenURL else {
            LogManager.shared.log("Failed to unwrap token url from source. Something's gone wrong.")
            return
        }

        NSWorkspace.shared.open(url)
    }

    @IBAction func goPressed(_ sender: Any) {
        goButton.isEnabled = false

        guard let source = source else {
            LogManager.shared.log("Got to source save without selecting a source, something has gone wrong.")
            goButton.isEnabled = true
            return
        }

        var jiraInfo: JiraAuthInfo?
        if source == .jira {
            if !userField.stringValue.isEmpty && !domainField.stringValue.isEmpty {
                jiraInfo = JiraAuthInfo(
                    user: userField.stringValue,
                    domain: domainField.stringValue
                )
            } else {
                if userField.stringValue.isEmpty { userField.flashColor(NSColor.red) }
                if domainField.stringValue.isEmpty { domainField.flashColor(NSColor.red) }
                goButton.isEnabled = true
                return
            }
        }

        guard !tokenField.stringValue.isEmpty else {
            tokenField.flashColor(NSColor.red)
            goButton.isEnabled = true
            return
        }

        NetworkCoordinator.shared.authenticateUser(
            source: source,
            token: tokenField.stringValue,
            jiraAuthInfo: jiraInfo,
            onSuccess: {
               self.delegate?.addTokenAuthDidComplete(self)
            }, onFailure: { error in
                self.goButton.isEnabled = true
                switch error.statusCode {
                case 003:
                    let newToken = Token(created: Date(), source: source, username: error.message, domain: jiraInfo?.domain)
                    self.delegate?.addTokenAuthDidFailToken(self, error: error.message, token: newToken, key: self.tokenField.stringValue)
                case 401:
                    self.tokenField.flashColor(NSColor.red)
                    self.delegate?.addTokenAuthDidError(self, error: error.message)
                default:
                    self.delegate?.addTokenAuthDidError(self, error: error.message)
                }
            }
        )
    }

    func reset() {
        guard sourceItemView != nil else { return }
        source = nil
        userField.stringValue = ""
        domainField.stringValue = ""
        tokenField.stringValue = ""
    }
}

extension AddTokenAuthViewController: NSTextFieldDelegate {
    override func controlTextDidChange(_ obj: Notification) {
        if source == .jira {
            goButton.isEnabled = !tokenField.stringValue.isEmpty &&
                !userField.stringValue.isEmpty &&
                !domainField.stringValue.isEmpty
        } else {
            goButton.isEnabled = !tokenField.stringValue.isEmpty
        }
    }
}
