//
//  Log.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/03.
//

import Foundation
import os

extension OSLog {
    static let homeKitLog = OSLog(subsystem: "com.sonson.HomeConMenu.macOS", category: "HomeKit")
    static let appLog = OSLog(subsystem: "com.sonson.HomeConMenu.macOS", category: "Application")
}

extension Logger {
    static let homeKit = Logger(OSLog.homeKitLog)
    static let app = Logger(OSLog.appLog)
}
