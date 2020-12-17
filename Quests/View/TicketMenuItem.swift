//
//  TicketMenuItem.swift
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

class TicketMenuItem: NSMenuItem {
    init(from ticket: Ticket, length: Int) {
        super.init(title: ticket.name, action: #selector(ticketMenuItemPressed(_:)), keyEquivalent: "")
        target = self
        representedObject = ticket

        let showLabels = !Defaults[.dontShowLabels]
        let ticketView = TicketMenuItemView(frame: NSRect(x: 0, y: 0, width: getViewWidth(), height: 20), ticket: ticket, showLabels: showLabels)
        view = ticketView
    }

    required init(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc private func ticketMenuItemPressed(_ sender: NSMenuItem) {
        guard let menuItem = sender.representedObject as? Ticket else { return }
        if let url = URL(string: menuItem.url) {
            AnalyticsModel.shared.ticketOpened(type: (representedObject as? Ticket)?.type)
            NSWorkspace.shared.open(url)
        }
    }
}
