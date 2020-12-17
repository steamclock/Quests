//
//  TicketMenuItemView.swift
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

class TicketMenuItemView: NSView {

    private var ticket: Ticket!
    private var backgroundLabel: NSTextField!
    private var titleLabel: NSTextField!
    private var imageView: NSImageView!

    // MARK: Initializers

    init(frame: NSRect, ticket: Ticket, showLabels: Bool) {
        super.init(frame: frame)

        self.ticket = ticket

        imageView = NSImageView()
        addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.bottom.equalToSuperview()
        }

        if let image = ticket.type.image {
            imageView.image = image.imageWithTintColor(tintColor: NSColor.ThemeColor.text)
            imageView.snp.remakeConstraints { make in
                make.left.equalToSuperview().offset(15)
                make.centerY.equalToSuperview()
                make.width.height.equalTo(18)
            }
        }

        backgroundLabel = NSTextField.toLabel
        addSubview(backgroundLabel)
        backgroundLabel.backgroundColor = NSColor.clear
        backgroundLabel.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        backgroundLabel.sizeToFit()

        var rightAnchor = backgroundLabel.snp.right

        if showLabels {
            let maxLabelViewSize = frame.width * 0.6
            let labelsView = LabelsView(labels: ticket.labels, frame: NSRect(x: frame.maxX - maxLabelViewSize - 15, y: 0, width: maxLabelViewSize, height: frame.height))
            addSubview(labelsView)

            labelsView.snp.makeConstraints { make in
                make.top.bottom.equalTo(backgroundLabel)
                make.right.equalTo(backgroundLabel).inset(20)
            }

            rightAnchor = labelsView.snp.left
        }

        titleLabel = NSTextField.toLabel
        titleLabel.stringValue = ticket.name
        titleLabel.font = NSFont.systemFont(ofSize: 14)
        titleLabel.cell?.lineBreakMode = .byTruncatingTail
        titleLabel.cell?.alignment = .left
        titleLabel.backgroundColor = NSColor.clear
        addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.left.equalTo(imageView.snp.right)
            make.right.lessThanOrEqualTo(rightAnchor).offset(-8)
            make.centerY.equalToSuperview()
        }
    }

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: View Overrides

    override func draw(_ dirtyRect: NSRect) {
        if enclosingMenuItem?.isHighlighted == true {
            NSColor.keyboardFocusIndicatorColor.setFill()
            toggleHighlighted(true)
            dirtyRect.fill()
        } else {
            toggleHighlighted(false)
            super.draw(dirtyRect)
        }
    }

    override func mouseUp(with event: NSEvent) {
        guard let menuItem = enclosingMenuItem, let menu = menuItem.menu else { return }
        menu.cancelTracking()
        menu.performActionForItem(at: menu.index(of: menuItem))
    }

    // MARK: Helpers

    private func toggleHighlighted(_ on: Bool) {
        let color = on ? NSColor.ThemeColor.highlightedText : NSColor.ThemeColor.text
        titleLabel.textColor = color
        backgroundLabel.textColor = color

        if let image = ticket.type.image {
            image.isTemplate = true
            imageView.image = ticket.type.image?.imageWithTintColor(tintColor: on ? NSColor.ThemeColor.highlightedText : NSColor.ThemeColor.text)
        }
    }
}
