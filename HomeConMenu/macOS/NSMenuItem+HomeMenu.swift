//
//  NSMenuItem+HomeMenu.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/21.
//

import Foundation
import AppKit

extension NSMenuItem {
    class func HomeMenus(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) -> [NSMenuItem?] {
        switch serviceInfo.type {
        case .humiditySensor, .temperatureSensor:
            return [SensorMenuItem(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo)]
        case .lightbulb:
            return [PowerMenuItem(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios), LightColorMenuItem(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)]
        case .outlet, .switch:
            return [PowerMenuItem(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)]
        default:
            return []
        }
    }
}
