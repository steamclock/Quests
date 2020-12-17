//
//  TicketReminderItem.swift
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

enum ReminderDestination {
    case accounts
    case reconnect
    case url(_ url: String)
}

class ReminderItem: NSMenuItem {
    var destination: ReminderDestination?

    init(title: String? = nil, subtitle: String, destination: ReminderDestination? = nil) {
        super.init(title: "", action: nil, keyEquivalent: "")

        let titleLabel = NSTextField.toLabel
        titleLabel.stringValue = title ?? ""
        titleLabel.alignment = .center
        titleLabel.sizeToFit()
        titleLabel.isHidden = title == nil

        let reminderLabel = NSTextField.toLabel
        reminderLabel.stringValue = subtitle
        reminderLabel.maximumNumberOfLines = 2
        reminderLabel.alignment = .center
        reminderLabel.textColor = NSColor.secondaryLabelColor
        reminderLabel.sizeToFit()

        let titleHeight = title != nil ? 18 : 0
        let reminderHeight = Int(reminderLabel.frame.height) // 15 or 30
        let baseHeight = 30

        let containerView = NSView(frame: NSRect(x: 0, y: 0, width: getViewWidth(), height: baseHeight + titleHeight + reminderHeight))
        view = containerView

        let stackView = NSStackView()
        stackView.orientation = .vertical
        containerView.addSubview(stackView)

        stackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.left.right.equalToSuperview().inset(8)
            make.bottom.equalToSuperview().inset(4)
        }

        stackView.insertArrangedSubview(titleLabel, at: 0)
        stackView.insertArrangedSubview(reminderLabel, at: 1)

        self.destination = destination

        let selectionLayer = NSButton(title: "", target: self, action: #selector(reminderPressed(_:)))
        selectionLayer.bezelStyle = .regularSquare // The default style has a fixed height
        selectionLayer.isTransparent = true
        containerView.addSubview(selectionLayer)

        selectionLayer.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func reminderPressed(_ sender: NSMenuItem) {
        guard let destination = destination else { return }

        switch destination {
        case .accounts:
            NotificationCenter.default.post(
                name: .shouldOpenSettings,
                object: self
            )
        case .reconnect:
            break
        case .url(let urlString):
            if let url = URL(string: urlString) {
                NSWorkspace.shared.open(url)
            }
        }
    }
}
