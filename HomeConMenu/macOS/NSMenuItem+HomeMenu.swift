//
//  NSMenuItem+HomeMenu.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/21.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//

import Foundation
import AppKit

extension NSMenuItem {
    class func HomeMenus(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) -> [NSMenuItem?] {
        switch serviceInfo.type {
        case .humiditySensor, .temperatureSensor:
            return [SensorMenuItem(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo)]
        case .lightbulb:
            return [LightbulbMenuItem(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)]
        case .outlet, .switch:
            return [PowerMenuItem(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)]
        default:
            return []
        }
    }
}

extension NSMenu {
    static func getSubItems(menu: NSMenu) -> [NSMenuItem] {
        
        var buffer: [NSMenuItem] = []
        
        for item in menu.items {
            buffer.append(item)
            if let submenu = item.submenu {
                buffer.append(contentsOf: getSubItems(menu: submenu))
            }
        }
        
        return buffer
    }
}
