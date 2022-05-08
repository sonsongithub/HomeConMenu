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
    class func HomeMenus(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) -> [NSMenuItem?] {
        switch serviceInfo.type {
        case .humiditySensor, .temperatureSensor:
            return [SensorMenuItem(serviceInfo: serviceInfo)]
        case .lightbulb:
            return [LightbulbMenuItem(serviceInfo: serviceInfo, mac2ios: mac2ios)]
        case .switch:
            return [SwitchMenuItem(serviceInfo: serviceInfo, mac2ios: mac2ios)]
        case .outlet:
            return [OutletMenuItem(serviceInfo: serviceInfo, mac2ios: mac2ios)]
        default:
            return []
        }
    }
    
    class func HomeMenus(serviceGroup: ServiceGroupInfoProtocol, mac2ios: mac2iOS?) -> [NSMenuItem?] {
        
        let serviceTypes = Set(serviceGroup.services.map({ $0.type}))
        
        var buffer = Set(serviceGroup.services[0].characteristics.map({ $0.type }))
        for service in serviceGroup.services {
            buffer = Set(service.characteristics.map({$0.type})).intersection(buffer)
        }
        if buffer.contains(.powerState) && serviceTypes.contains(.outlet) {
            return [OutletMenuItem(serviceGroupInfo: serviceGroup, mac2ios: mac2ios)]
        }
        if buffer.contains(.powerState) && serviceTypes.contains(.switch) {
            return [SwitchMenuItem(serviceGroupInfo: serviceGroup, mac2ios: mac2ios)]
        }
        if buffer.contains(.powerState) && serviceTypes.contains(.lightbulb) {
            return [LightbulbMenuItem(serviceGroupInfo: serviceGroup, mac2ios: mac2ios)]
        }
        return []
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
