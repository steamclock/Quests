//
//  NSTextField+FlashColor.swift
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

extension NSTextField {
    func flashColor(_ color: NSColor) {
        let originalTextColor = textColor
        let maxFlashes = 3

        wantsLayer = true
        layer?.borderWidth = 2
        layer?.cornerRadius = 4
        layer?.borderColor = color.cgColor

        textColor = color

        var flashCount = 0
        Timer.scheduledTimer(withTimeInterval: 0.5, repeats: true) { timer in
            if self.textColor == originalTextColor {
                self.textColor = color
                self.layer?.borderColor = color.cgColor
            } else {
                self.textColor = originalTextColor
                self.layer?.borderColor = NSColor.clear.cgColor
            }
            flashCount += 1
            if flashCount > maxFlashes {
                timer.invalidate()
                self.textColor = originalTextColor
                self.layer?.borderColor = NSColor.clear.cgColor
            }
        }
    }
}
