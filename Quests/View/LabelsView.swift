//
//  LabelsView.swift
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

class LabelsView: NSView {
    init(labels: [Label], frame: NSRect) {
        super.init(frame: frame)

        var previousLabel: NSTextField?
        var spaceRemaining: CGFloat = frame.width
        let labelSpacing: CGFloat = 6

        for label in labels {
            let labelView = LabelView(label: label)

            // Don't add the label if it's not going to fit, move on and try the next one
            guard spaceRemaining > labelView.frame.width else { continue }
            spaceRemaining -= (labelView.frame.width + labelSpacing)
            addSubview(labelView)
            let width = labelView.frame.width - 2

            labelView.snp.updateConstraints { make in
                make.top.bottom.equalToSuperview().inset(1)
                make.width.equalTo(width)

                if previousLabel == nil {
                    make.right.equalToSuperview().offset(-2)
                } else {
                    make.right.equalTo(previousLabel!.snp.left).offset(-labelSpacing)
                }
            }
            previousLabel = labelView
        }

        if let previous = previousLabel {
            snp.makeConstraints { make in
                make.left.equalTo(previous).offset(-4)
            }
        }
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        nil
    }
}
