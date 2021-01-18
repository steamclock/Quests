//
//  UpdateModel.swift
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

import Foundation
import Netable
import SwiftyUserDefaults

struct Batsignal: Decodable {
    let title: String
    let message: String
    let url: String
}

struct CheckForBatsignal: Request {
    typealias Parameters = Empty
    typealias RawResource = Batsignal

    public var method: HTTPMethod { .get }

    public var path: String {
        "notify.json"
    }
}

struct VersionInfo: Decodable {
    let version: String
    let url: String
    let notes: String
}

struct CheckForNewVersion: Request {
    typealias Parameters = Empty
    typealias RawResource = VersionInfo

    public var method: HTTPMethod { .get }

    public var path: String { "version.json" }
}

enum AppSource: String {
    case debug
    case testFlight
    case appStore
}

class UpdateModel {
    static let shared = UpdateModel()

    private let updateAPI: Netable
    private let currentVersion: String
    private var batsignal: Batsignal?
    private var batsignalRetrievedAt: Date?

    private init() {
        updateAPI = Netable(baseURL: URL(string: "https://quests-beta.netlify.com/")!)
        updateAPI.headers["Accept"] = "application/json"
        currentVersion = Bundle.versionString
    }

    func checkForBatsignal(onSuccess: @escaping (Batsignal?) -> Void, onFailure: @escaping (NetableError) -> Void) {
        if let batsignal = batsignal, let batsignalDate = batsignalRetrievedAt,
                batsignalDate.timeIntervalSinceNow > -3600 { // Only update every hour
            onSuccess(batsignal)
            return
        }

        updateAPI.request(CheckForBatsignal()) { result in
            switch result {
            case .success(let batsignal):
                self.batsignal = batsignal
                self.batsignalRetrievedAt = Date()
                onSuccess(batsignal)
            case .failure(let error):
                onFailure(error)
            }
        }
    }

    func checkForUpdates(onSuccess: @escaping (VersionInfo?) -> Void, onFailure: @escaping (NetableError) -> Void) {
        Defaults[.updateLastChecked] = Date()

        updateAPI.request(CheckForNewVersion()) { result in
            switch result {
            case .success(let versionInfo):
                guard versionInfo.version.compare(self.currentVersion, options: .numeric) == .orderedDescending else {
                    LogManager.shared.log("Current version is the same as or newer than available")
                    onSuccess(nil)
                    return
                }

                LogManager.shared.log("Found a new version to download")
                onSuccess(versionInfo)
            case .failure(let error):
                onFailure(error)
            }
        }
    }

    func appSource() -> AppSource {
//        if isSimulator() {
//            return .debug
//        }

        #if INTERNAL
            return .testFlight
        #endif

        // When in doubt just show app store version
        return .appStore
    }

    private func isSimulator() -> Bool {
        #if arch(i386) || arch(x86_64)
        return true
        #else
        return false
        #endif
    }
}
