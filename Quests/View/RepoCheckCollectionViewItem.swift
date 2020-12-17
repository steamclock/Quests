//
//  RepoCheckCollectionViewItem.swift
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

protocol RepoCheckCollectionViewItemDelegate: AnyObject {
    func repoCheckCollectionViewItem(_ repoCheckCollectionViewItem: RepoCheckCollectionViewItem, didToggleShowAll: Bool)
}

class RepoCheckCollectionViewItem: NSCollectionViewItem {
    @IBOutlet var checkButton: NSButton!

    weak var showAllDelegate: RepoCheckCollectionViewItemDelegate?

    var repo: String? {
        didSet {
            guard let name = repo else { return }
            checkButton.title = name
            checkButton.lineBreakMode = .byTruncatingTail
        }
    }

    @IBAction func buttonChecked(_ sender: NSButton) {
       let name = checkButton.title

        guard showAllDelegate == nil else {
            showAllDelegate?.repoCheckCollectionViewItem(self, didToggleShowAll: sender.state == .on)
            return
        }

        switch sender.state {
        case .on:
            DefaultsKeys.removeIgnored(repo: name)
            AnalyticsModel.shared.repoToggled(on: true)
        case .off:
            DefaultsKeys.addIgnored(repo: name)
            AnalyticsModel.shared.repoToggled(on: false)
        default:
            return
        }
    }
}
