//
//  StatusBarView.swift
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

class StatusBarView: NSView {
    private var issueLabel: NSTextField!
    private var issueImageView: NSImageView!
    private var separatorImageView: NSImageView!
    private var prLabel: NSTextField!
    private var prImageView: NSImageView!

    private var issueImage: NSImage!
    private var separatorImage: NSImage!
    private var prImage: NSImage!

    var parent: NSStatusBarButton?
    var containerView: NSView!

    required init?(coder decoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: NSRect) {
        super.init(frame: frame)

        containerView = NSView()
        addSubview(containerView)
        containerView.snp.makeConstraints { make in
            make.top.bottom.left.equalToSuperview()
        }

        issueImage = NSImage(named: NSImage.Name("Issue"))!
        issueImage.isTemplate = true
        issueImageView = NSImageView(image: issueImage)
        issueImageView.wantsLayer = true
        containerView.addSubview(issueImageView)
        issueImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().offset(3)
        }

        issueLabel = NSTextField.toLabel
        containerView.addSubview(issueLabel)
        issueLabel.font = NSFont.systemFont(ofSize: 15, weight: .light)
        issueLabel.wantsLayer = true
        issueLabel.snp.makeConstraints { make in
            make.left.equalTo(issueImageView.snp.right).offset(-2)
            make.bottom.equalToSuperview().offset(-1)
        }
        issueLabel.sizeToFit()

        separatorImage = NSImage(named: NSImage.Name("separator"))
        separatorImage.isTemplate = true
        separatorImageView = NSImageView(image: separatorImage)
        separatorImageView.wantsLayer = true
        containerView.addSubview(separatorImageView)
        separatorImageView.snp.makeConstraints { make in
            make.width.height.equalTo(3)
            make.centerY.equalToSuperview()
            make.left.equalTo(issueLabel.snp.right).offset(2)
        }

        prImage = NSImage(named: NSImage.Name("Pull-Request"))!
        prImage.isTemplate = true
        prImageView = NSImageView(image: prImage)
        prImageView.wantsLayer = true
        containerView.addSubview(prImageView)
        prImageView.snp.makeConstraints { make in
            make.width.height.equalTo(18)
            make.centerY.equalToSuperview()
            make.left.equalTo(separatorImageView.snp.right).offset(1)
        }

        prLabel = NSTextField.toLabel
        containerView.addSubview(prLabel)
        prLabel.font = NSFont.systemFont(ofSize: 15, weight: .light)
        prLabel.wantsLayer = true
        prLabel.snp.makeConstraints { make in
            make.left.equalTo(prImageView.snp.right).offset(-1)
            make.bottom.equalToSuperview().offset(-1)
        }
        prLabel.sizeToFit()

        containerView.snp.makeConstraints { make in
            make.right.equalTo(prLabel).offset(5)
        }

        containerView.isHidden = true
    }

    func updateLabels(issueCount: Int, prCount: Int) {
        containerView.isHidden = false
        issueImageView.snp.updateConstraints { make in
            make.width.equalTo(Defaults[.onlyShowPRs] ? 0 : frame.height)
        }
        issueLabel.isHidden = Defaults[.onlyShowPRs]
        separatorImageView.isHidden = Defaults[.onlyShowPRs]

        prLabel.stringValue = "\(prCount)"
        issueLabel.stringValue = "\(issueCount)"

        issueLabel.needsLayout = true
        prLabel.needsLayout = true
        containerView.layout()
        containerView.layoutSubtreeIfNeeded()

        frame = NSRect(origin: frame.origin, size: CGSize(width: containerView.frame.width, height: frame.height))
    }

    override func draw(_ dirtyRect: NSRect) {
        guard let isHighlighted = self.parent?.isHighlighted else {
            return
        }

        let tintColor: NSColor

        if #available(macOS 11, *) {
            tintColor = NSColor.isDarkMode ? NSColor.white : NSColor.black
        } else {
            tintColor = NSColor.isDarkMode ? NSColor.white : (isHighlighted ? NSColor.white : NSColor.black)
        }

        issueImageView.image = issueImage.imageWithTintColor(tintColor: tintColor, imageName: "Issue")
        issueLabel.textColor = tintColor

        separatorImageView.image = separatorImage.imageWithTintColor(tintColor: tintColor, imageName: "separator")

        prImageView.image = prImage.imageWithTintColor(tintColor: tintColor, imageName: "Pull-Request")
        prLabel.textColor = tintColor
    }
}
