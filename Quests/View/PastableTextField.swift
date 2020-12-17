//
//  PastableTextField.swift
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

class PastableTextField: NSTextField {
    override func performKeyEquivalent(with event: NSEvent) -> Bool {

        // Check if they entered command + some key
        guard let responder = window?.firstResponder,
            let textView = responder as? NSTextView,
            let pastedString = NSPasteboard.general.string(forType: .string),
            event.modifierFlags.contains(.command) else {
            return true
        }

        switch event.keyCode {
        case 0: // A
            textView.setSelectedRange(NSRange(location: 0, length: textView.string.count))
        case 7: // X
            NSPasteboard.general.setString(textView.string, forType: .string)
            textView.string = ""
        case 8: // C
            NSPasteboard.general.setString(textView.string, forType: .string)
        case 9: // V
            textView.string = pastedString
        default: break
        }

        textView.didChangeText()

        return true
    }
}
