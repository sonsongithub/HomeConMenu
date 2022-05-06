//
//  MacOSController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/02.
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
import os

class MacOSController: NSObject, iOS2Mac, NSMenuDelegate {
    
    let mainMenu = NSMenu()
    var iosListener: mac2iOS?
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        
    func menuWillOpen(_ menu: NSMenu) {
        let items = NSMenu.getSubItems(menu: menu)
        let uuids = items.compactMap({ item in
            item as? MenuItemFromUUID
        }).map({ item in
            item.UUIDs()
        }).flatMap({$0})
        iosListener?.reload(uniqueIdentifiers: uuids)
    }
    
    func openNoHomeError() {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("HomeKit error", comment: "")
        alert.informativeText = NSLocalizedString("HomeConMenu can not find any Homes of HomeKit. Please confirm your HomeKit devices on Home.app.", comment:"")
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        _ = alert.runModal()
    }
    
    func openHomeKitAuthenticationError() -> Bool {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Authentication error", comment: "")
        alert.informativeText = NSLocalizedString("HomeConMenu can not access HomeKit because of your privacy settings. Please allow HomeConMenu to access HomeKit via System Preferences.app.", comment:"")
        alert.alertStyle = .informational

        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: NSLocalizedString("Open System Preferences.app", comment: ""))
        
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
    
    var menuItemCount: Int {
        get {
            return mainMenu.numberOfItems
        }
    }

    func bringToFront() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func centeringWindows() {
        for window in NSApp.windows {
            window.center()
        }
    }
    
    func didUpdate(chracteristicInfo: CharacteristicInfoProtocol) {
        
        let items = NSMenu.getSubItems(menu: mainMenu)
        
        // まずここで候補のメニューアイテムを全部列挙する
        let candidates = items.compactMap({ item in
            item as? MenuItemFromUUID
        }).filter ({ item in
            item.bind(with: chracteristicInfo.uniqueIdentifier)
        })
        
        for item in candidates {
            
            switch (item, chracteristicInfo.value, chracteristicInfo.type) {
            case (let item as LightbulbMenuItem, let value as Int, .powerState):
                item.update(value: value)
            case (let item as LightColorMenuItem, let value as CGFloat, .hue):
                item.update(hueFromHMKit: value, saturationFromHMKit: nil, brightnessFromHMKit: nil)
                item.isEnabled = chracteristicInfo.enable
            case (let item as LightColorMenuItem, let value as CGFloat, .saturation):
                item.update(hueFromHMKit: nil, saturationFromHMKit: value, brightnessFromHMKit: nil)
                item.isEnabled = chracteristicInfo.enable
            case (let item as LightColorMenuItem, let value as CGFloat, .brightness):
                item.update(hueFromHMKit: nil, saturationFromHMKit: nil, brightnessFromHMKit: value)
                item.isEnabled = chracteristicInfo.enable
            case (let item as ToggleMenuItem, let value as Int, _):
                item.update(value: value)
                item.isEnabled = chracteristicInfo.enable
            case (let item as SensorMenuItem, let value, _):
                item.update(value: value)
                item.isEnabled = false
            default:
                do {}
            }
        }
        
    }
    
    func didUpdate() {
        mainMenu.removeAllItems()
        guard let accessories = self.iosListener?.accessories else { return }
        guard let serviceGroups = self.iosListener?.serviceGroups else { return }
        guard let rooms = self.iosListener?.rooms else { return }
        
        // group
//        for serviceGroup in serviceGroups {
//            for service in serviceGroup.services {
//                print(service.name ?? "No name")
//                print(service.type)
//                print(service.characteristics)
//            }
//        }
        
        // room
        for room in rooms {
            var buffer: [NSMenuItem] = []
            let roomNameItem = NSMenuItem()
            roomNameItem.title = room.name ?? ""
                
            buffer.append(roomNameItem)
            
            for info in accessories {
                if info.room?.uniqueIdentifier == room.uniqueIdentifier {
                    var items: [NSMenuItem?] = []
                    
                    items.append(CameraMenuItem(accessoryInfo: info, mac2ios: iosListener))
                    items.append(contentsOf: info.services.map { serviceInfo in
                        NSMenuItem.HomeMenus(serviceInfo: serviceInfo, mac2ios: iosListener)
                    }.flatMap({$0}))
                    
                    let candidates = items.compactMap({$0})
                    buffer.append(contentsOf: candidates)
                }
            }
            if  buffer.count > 1 {
                for menuItem in buffer {
                    mainMenu.addItem(menuItem)
                }
                mainMenu.addItem(NSMenuItem.separator())
            }
        }
        
        let a = serviceGroups.compactMap({ NSMenuItem.HomeMenus(serviceGroup: $0, mac2ios: iosListener) }).flatMap({ $0 }).compactMap({$0})
        
        for item in a {
            mainMenu.addItem(item)
        }
        
        if mainMenu.items.count == 0 {
            UserDefaults.standard.set(false, forKey: "doesNotShowLaunchViewController")
            UserDefaults.standard.synchronize()
        } else {
            mainMenu.addItem(NSMenuItem.separator())
        }
        
        let abouItem = NSMenuItem()
        abouItem.title = "About HomeConMenu"
        abouItem.action = #selector(MacOSController.about(sender:))
        abouItem.target = self
        mainMenu.addItem(abouItem)
        
        mainMenu.addItem(NSMenuItem.separator())
        
        let menuItem = NSMenuItem()
        menuItem.title = "Quit HomeConMenu"
        menuItem.action = #selector(MacOSController.quit(sender:))
        menuItem.target = self
        mainMenu.addItem(menuItem)
    }
    
    required override init() {
        super.init()
        if let button = self.statusItem.button {
            button.image = NSImage.init(systemSymbolName: "house", accessibilityDescription: nil)
        }
        self.statusItem.menu = mainMenu
        mainMenu.delegate = self
    }
    
    @IBAction func about(sender: NSButton) {
        self.iosListener?.openAbout()
    }
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}

