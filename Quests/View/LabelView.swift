//
//  LabelView.swift
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

class LabelView: NSTextField {
    init(label: Label) {
        super.init(frame: NSRect.zero)

        isBezeled = true
        isEditable = false
        isSelectable = false
        drawsBackground = false
        maximumNumberOfLines = 1
        isBordered = false

        wantsLayer = true
        layer?.borderColor = label.color.cgColor
        layer?.borderWidth = 2
        layer?.cornerRadius = 2
        layer?.backgroundColor = label.color.cgColor

        textColor = getTextColor(for: label.color)
        stringValue = label.title
        sizeToFit()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func getTextColor(for background: NSColor) -> NSColor {
        // Prefer to use white text, but default to black if there isn't enough contrast with white
        let blackConstrast = background.contrastRatio(with: NSColor.black)
        let whiteContrast = background.contrastRatio(with: NSColor.white)

        if whiteContrast > 4.5 || whiteContrast > blackConstrast {
            return NSColor.white
        }
        return NSColor.black
    }
}
