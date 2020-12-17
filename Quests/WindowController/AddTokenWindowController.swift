//
//  AddTokenWindowController.swift
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

protocol AddTokenDelegate: AnyObject {
    func addTokenWindowControllerDidEnterToken(_ addTokenWindowController: AddTokenWindowController)
}

class AddTokenWindowController: NSWindowController {
    private var sourceViewController: AddTokenSourceViewController?
    private var authViewController: AddTokenAuthViewController?

    weak var delegate: AddTokenDelegate?

    var isFirstUse = false {
        didSet {
            sourceViewController?.isFirstUse = isFirstUse
        }
    }

    override func windowDidLoad() {
        super.windowDidLoad()

        sourceViewController = AddTokenSourceViewController(nibName: NSNib.Name("AddTokenSourceViewController"), bundle: nil)
        sourceViewController?.delegate = self

        authViewController = AddTokenAuthViewController(nibName: NSNib.Name("AddTokenAuthViewController"), bundle: nil)
        authViewController?.delegate = self

        window?.contentViewController = sourceViewController
        sourceViewController?.isFirstUse = isFirstUse
    }

    func reset() {
        // We don't want this to run if the window hasn't loaded yet
        guard let authView = authViewController else { return }
        authView.reset()
        window?.contentViewController = sourceViewController
    }
}

extension AddTokenWindowController: AddTokenSourceDelegate {
    func addTokenSourceSelected(_ addTokenSourceViewController: AddTokenSourceViewController, source: Source) {
        authViewController?.source = source
        window?.contentViewController = authViewController
    }
}

extension AddTokenWindowController: AddTokenAuthDelegate {
    func addTokenAuthDidComplete(_ addTokenAuthViewController: AddTokenAuthViewController) {
        delegate?.addTokenWindowControllerDidEnterToken(self)
    }

    func addTokenAuthDidCancel(_ addTokenAuthViewController: AddTokenAuthViewController) {
        addTokenAuthViewController.source = nil
        window?.contentViewController = sourceViewController
    }

    func addTokenAuthDidError(_  addTokenAuthViewController: AddTokenAuthViewController, error: String) {
        showAlert(message: error)
    }

    func addTokenAuthDidFailToken(_ addTokenAuthViewController: AddTokenAuthViewController, error: String, token: Token, key: String) {

        let alert = NSAlert()
        alert.messageText = "We couldn't retrieve any issues for that token, you may not have given the token the 'repo' scope. Did you mean to do this?"
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Keep using this token")
        alert.addButton(withTitle: "Cancel")

        alert.beginSheetModal(for: self.window!) { response in
            if response == NSApplication.ModalResponse.alertFirstButtonReturn {
                // Keep this token pressed
                DefaultsKeys.add(token: token)
                try? Valet.shared.setString(key, forKey: token.key)
                AnalyticsModel.shared.tokenAdded(source: token.source)

                self.close()
            }
        }
    }
}
