//
//  MacOSController+iOS2Mac.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/12/10.
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
import KeyboardShortcuts
import AppKit
import os

extension MacOSController {
    
    func bringToFront() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func centeringWindows() {
        for window in NSApp.windows {
            window.center()
        }
    }
    
    func setReachablityOfMenuItemRelated(to uniqueIdentifier: UUID, using isReachable: Bool) {
        let items = NSMenu.getSubItems(menu: mainMenu)
        
        let candidates = items.compactMap({ item in
            item as? MenuItemFromUUID
        }).filter ({ item in
            item.bind(with: uniqueIdentifier)
        })
        
        for item in candidates {
            switch (item) {
            case let item as ToggleMenuItem:
                item.reachable = isReachable
            case let item as SensorMenuItem:
                item.reachable = isReachable
            default:
                do {}
            }
        }
    }
    
    func updateMenuItemsRelated(to uniqueIdentifier: UUID, using value: Any) {
        let items = NSMenu.getSubItems(menu: mainMenu)
        
        let candidates = items.compactMap({ item in
            item as? MenuItemFromUUID
        }).filter ({ item in
            item.bind(with: uniqueIdentifier)
        })
        
        for item in candidates {
            switch (item, value) {
            case (let item as ToggleMenuItem, let boolValue as Bool):
                item.update(value: boolValue)
            case (let item as LightColorMenuItem, let doubleValue as Double):
                item.update(of: uniqueIdentifier, value: doubleValue)
            case (let item as SensorMenuItem, let doubleValue as Double):
                item.update(value: doubleValue)
            case (let item as ActionSetMenuItem, _):
                item.update()
            default:
                do {}
            }
        }
    }
    
    @MainActor
    func reloadMenuExtra() {
        KeyboardShortcuts.removeAllHandlers()
        NSMenu.getSubItems(menu: mainMenu).forEach({ $0.cancelKeyboardShortcut() })
        mainMenu.removeAllItems()
        reloadHomeKitMenuItems()
        reloadMusicAppMenuItems()
        reloadHomeMenuItems()
        let excludedServiceUUIDs = getExcludedServiceUUIDs()
        reloadSceneMenuItems()
        reloadEachRooms(excludedServiceUUIDs: excludedServiceUUIDs)
        reloadNoRoomAccessories(excludedServiceUUIDs: excludedServiceUUIDs)
        reloadServiceGroupMenuItem()
        reloadOtherItems()
    }

    func showLaunchView() {
        launchWindowController.showWindow(self)
        centeringWindows()
        self.bringToFront()
        
        preferences(sender: nil)
    }
    
    /// Open dialog to open System Preferences.app.
    /// This method is called from MacCatalyst when HomeKit authentication is not allowed.
    func openNoHomeError() {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("HomeKit error", comment: "")
        alert.informativeText = NSLocalizedString("HomeConMenu can not find any Homes of HomeKit. Please confirm your HomeKit devices on Home.app.", comment:"")
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        _ = alert.runModal()
    }
    
    func openHomeKitAuthenticationError() -> Bool {
        Logger.app.info("openHomeKitAuthenticationError")
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Failed to access HomeKit because of your privacy settings.", comment: "")
        alert.informativeText = NSLocalizedString("Allow HomeConMenu to access HomeKit in System Settings.", comment:"")
        alert.alertStyle = .informational

        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: NSLocalizedString("Open System Settings", comment: ""))
        
        let ret = alert.runModal()
        switch ret {
        case .alertSecondButtonReturn:
            Logger.app.info("Open System Preferences.app")
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_HomeKit") {
                NSWorkspace.shared.open(url)
            }
            return true
        default:
            Logger.app.info("Does not open System Preferences.app")
            return false
        }
    }
    
}
