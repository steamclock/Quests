//
//  NewVersionWindowController.swift
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
import Down

class NewVersionWindowController: NSWindowController {
    @IBOutlet private var notesLabel: NSTextField!

    var versionInfo: VersionInfo?

    override func windowDidLoad() {
        super.windowDidLoad()

        guard let info = versionInfo else { return }

        // Because Down only supports h1 and h2, we need to convert our input from using h2 and h3 to using h1 and h2.
        let modifiedNotes = info.notes.replacingOccurrences(of: "##", with: "#")
        guard let attributedString = try? Down(markdownString: modifiedNotes).toAttributedString() else { return }

        let finalString = NSMutableAttributedString(attributedString: attributedString)
        finalString.addAttributes([NSAttributedStringKey.foregroundColor: NSColor.textColor], range: NSRange(location: 0, length: finalString.length))
        notesLabel.attributedStringValue = finalString
    }

    @IBAction func cancelPressed(_ sender: Any) {
        close()
    }

    @IBAction func downloadPressed(_ sender: Any) {
        guard let urlString = versionInfo?.url, let url = URL(string: urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "") else {
            LogManager.shared.log("Failed to unwrap url from new version info, something's gone wrong.")
            return
        }

        NSWorkspace.shared.open(url)
    }
}
