//
//  LogManager.swift
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
import XCGLogger

class LogManager {
    // Enforce singleton
    static let shared = LogManager()

    private let logger = XCGLogger(identifier: "Quests", includeDefaultDestinations: true)

    private let logFileName = "quests_debug.txt"
    private var logFileMonitorSource: DispatchSourceFileSystemObject?
    private var logFileDescriptor: CInt = 0

    private var documentUrl: URL? {
        do {
            return try FileManager.default.url(
                for: .documentDirectory,
                in: .userDomainMask,
                appropriateFor: nil,
                create: true)
        } catch {
            return nil
        }
    }

    private init() {
        // Prevent accidental new allocations.
        logger.setup(
            level: .debug,
            showLogIdentifier: true,
            showFunctionName: false,
            showThreadName: true,
            showLevel: false,
            showFileNames: false,
            showLineNumbers: false,
            showDate: true)

        guard let documentUrl = documentUrl else {
            log("App document URL not found, cannot create log file destination")
            return
        }

        let fileDestination = AutoRotatingFileDestination(
            writeToFile: documentUrl.appendingPathComponent(logFileName),
            identifier: "Quests.File",
            shouldAppend: true)

        fileDestination.outputLevel = .debug
        fileDestination.targetMaxTimeInterval = 0
        fileDestination.showLogIdentifier = true
        fileDestination.showFunctionName = false
        fileDestination.showThreadName = true
        fileDestination.showLevel = false
        fileDestination.showFileName = false
        fileDestination.showLineNumber = false
        fileDestination.showDate = true
        fileDestination.logQueue = XCGLogger.logQueue

        logger.add(destination: fileDestination)
    }

    func log(_ string: String) {
        logger.debug(string)
    }

    func getLogFile() -> URL? {
        guard let documentUrl = documentUrl else {
            return nil
        }

        return documentUrl.appendingPathComponent(logFileName)
    }

    func getLogs() -> String? {
        guard let documentUrl = documentUrl else {
            return nil
        }

        do {
            return try String(contentsOf: documentUrl.appendingPathComponent(logFileName))
        } catch {
            return nil
        }
    }

    func clearLogs() {
        guard let documentUrl = documentUrl else {
            return
        }

        do {
            try "".write(
                toFile: documentUrl.appendingPathComponent(logFileName).path,
                atomically: false,
                encoding: .utf8
            )
        } catch {
            return
        }
    }
}
