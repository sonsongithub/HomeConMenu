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
import KeyboardShortcuts

class MacOSController: NSObject, iOS2Mac, NSMenuDelegate {
    
    let mainMenu = NSMenu()
    var iosListener: mac2iOS?
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    func menuWillOpen(_ menu: NSMenu) {
        let items = NSMenu.getSubItems(menu: menu)
            .compactMap({ $0 as? ErrorMenuItem})
            .filter({ !$0.reachable })
            .compactMap({ $0 as? MenuItemFromUUID })
            .compactMap({ $0.UUIDs() })
            .flatMap({ $0 })
        
        for uniqueIdentifider in items {
            iosListener?.readCharacteristic(of: uniqueIdentifider)
        }
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
        alert.messageText = NSLocalizedString("Failed to access HomeKit because of your privacy settings.", comment: "")
        alert.informativeText = NSLocalizedString("Allow HomeConMenu to access HomeKit in System Preferences.", comment:"")
        alert.alertStyle = .informational

        alert.addButton(withTitle: "OK")
        alert.addButton(withTitle: NSLocalizedString("Open System Preferences", comment: ""))
        
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
    
    func bringToFront() {
        NSApp.activate(ignoringOtherApps: true)
    }
    
    func centeringWindows() {
        for window in NSApp.windows {
            window.center()
        }
    }
    
    func updateItems(of uniqueIdentifier: UUID, isReachable: Bool) {
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
    
    func updateItems(of uniqueIdentifier: UUID, value: Any) {
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
    
    func actionItems() -> [String] {
        
        var names: [String] = []
        
//        if let serviceGroups = self.iosListener?.serviceGroups {
//            names.append(contentsOf: serviceGroups.map({ $0.name }))
//        }
        
        if let actionSets = self.iosListener?.actionSets {
            names.append(contentsOf: actionSets.map({ $0.name }))
        }
        
        print(names)
        
        if let accessories = self.iosListener?.accessories, let rooms = self.iosListener?.rooms {
            for room in rooms {
                for info in accessories {
                    if info.room?.uniqueIdentifier == room.uniqueIdentifier {
                        info.services.forEach { serviceInfo in
                            switch serviceInfo.type {
                            case .lightbulb:
                                names.append(serviceInfo.name)
                            case .outlet:
                                names.append(serviceInfo.name)
                            case .switch:
                                names.append(serviceInfo.name)
                            default:
                                do {}
                            }
                        }
                    }
                }
            }
        }
        return names
    }
    
    func reloadServiceGroupMenuItem() {
        guard let serviceGroups = self.iosListener?.serviceGroups else { return }
        
        let serviceGroupItems = serviceGroups.compactMap({ NSMenuItem.HomeMenus(serviceGroup: $0, mac2ios: iosListener) }).flatMap({ $0 }).compactMap({$0})
        
        if serviceGroupItems.count > 0 {
            let groupItem = NSMenuItem()
            groupItem.title = NSLocalizedString("Group", comment: "")
            groupItem.image = NSImage(systemSymbolName: "rectangle.3.group", accessibilityDescription: nil)
            mainMenu.addItem(groupItem)
            for item in serviceGroupItems {
                mainMenu.addItem(item)
            }
            mainMenu.addItem(NSMenuItem.separator())
        }
    }
    
    func reloadSceneMenuItems() {
        guard UserDefaults.standard.bool(forKey: "useScenes") else { return }
        guard let actionSets = self.iosListener?.actionSets else { return }
        if actionSets.count > 0 {
            let titleItem = NSMenuItem()
            titleItem.title = NSLocalizedString("Scene", comment: "")
            titleItem.image = NSImage(systemSymbolName: "moon.stars", accessibilityDescription: nil)
            mainMenu.addItem(titleItem)
            
            let subMenu = NSMenu()
            titleItem.submenu = subMenu
            for actionSet in actionSets {
                subMenu.addItem(ActionSetMenuItem(actionSetInfo: actionSet, mac2ios: iosListener))
            }
            mainMenu.addItem(NSMenuItem.separator())
        }
    }
    
    func reloadEachRooms(excludedServiceUUIDs: [UUID]) {
        guard let accessories = self.iosListener?.accessories else { return }
        guard let rooms = self.iosListener?.rooms else { return }
        
        let allowDuplicatingServices = UserDefaults.standard.bool(forKey: "allowDuplicatingServices")
        
        // room
        for room in rooms {
            var buffer: [NSMenuItem] = []
            let roomNameItem = NSMenuItem()
            roomNameItem.title = room.name
            roomNameItem.image = NSImage(systemSymbolName: "square.split.bottomrightquarter", accessibilityDescription: nil)
            
            for info in accessories {
                if info.room?.uniqueIdentifier == room.uniqueIdentifier {
                    var items: [NSMenuItem?] = []
                    
                    if allowDuplicatingServices {
                        items.append(CameraMenuItem(accessoryInfo: info, mac2ios: iosListener))
                        items.append(contentsOf: info.services.map { serviceInfo in
                            NSMenuItem.HomeMenus(serviceInfo: serviceInfo, mac2ios: iosListener)
                        }.flatMap({$0}))
                    } else {
                        items.append(CameraMenuItem(accessoryInfo: info, mac2ios: iosListener))
                        items.append(contentsOf: info.services.filter({ !excludedServiceUUIDs.contains($0.uniqueIdentifier) })
                            .map { serviceInfo in
                            NSMenuItem.HomeMenus(serviceInfo: serviceInfo, mac2ios: iosListener)
                        }.flatMap({$0}))
                    }
                    
                    let candidates = items.compactMap({$0})
                    buffer.append(contentsOf: candidates)
                }
            }
            if buffer.count > 1 {
                buffer = buffer.compactMap({ $0 as? MenuItemOrder })
                    .sorted(by: { lhs, rhs in
                        lhs.orderPriority > rhs.orderPriority
                    })
                    .compactMap({ $0 as? NSMenuItem })
                
                buffer.insert(roomNameItem, at: 0)
                
                for menuItem in buffer {
                    mainMenu.addItem(menuItem)
                }
                mainMenu.addItem(NSMenuItem.separator())
            }
        }
    }
    
    func reloadOtherItems() {
        let abouItem = NSMenuItem()
        abouItem.title = NSLocalizedString("About HomeConMenu", comment: "")
        abouItem.action = #selector(MacOSController.about(sender:))
        abouItem.target = self
        mainMenu.addItem(abouItem)
        
        let prefItem = NSMenuItem()
        prefItem.title = NSLocalizedString("Preferences…", comment: "")
        prefItem.action = #selector(MacOSController.preferences(sender:))
        prefItem.target = self
        mainMenu.addItem(prefItem)
        
        let openHomeItem = NSMenuItem()
        openHomeItem.title = NSLocalizedString("Open Home.app", comment: "")
        openHomeItem.action = #selector(MacOSController.openHomeApp(sender:))
        openHomeItem.target = self
        mainMenu.addItem(openHomeItem)
        
        mainMenu.addItem(NSMenuItem.separator())
        
        let menuItem = NSMenuItem()
        menuItem.title = NSLocalizedString("Quit HomeConMenu", comment: "")
        menuItem.action = #selector(MacOSController.quit(sender:))
        menuItem.target = self
        mainMenu.addItem(menuItem)
    }
    
    func getExcludedServiceUUIDs() -> [UUID] {
        guard let serviceGroups = self.iosListener?.serviceGroups else { return [] }
        return serviceGroups.compactMap({ $0.services }).flatMap({$0}).map({$0.uniqueIdentifier})
    }
    
    func reloadAllMenuItems() {
        mainMenu.removeAllItems()
        let excludedServiceUUIDs = getExcludedServiceUUIDs()
        reloadSceneMenuItems()
        reloadEachRooms(excludedServiceUUIDs: excludedServiceUUIDs)
        reloadServiceGroupMenuItem()
        reloadOtherItems()
        
        preferences(sender: nil)
    }
    
    required override init() {
        super.init()
        if let button = self.statusItem.button {
            button.image = NSImage.init(systemSymbolName: "house", accessibilityDescription: nil)
        }
        self.statusItem.menu = mainMenu
        mainMenu.delegate = self
    }
    
    @IBAction func preferences(sender: NSButton?) {
        let windowController = SettingsWindowController()
        if let a = windowController.settingsTabViewController {
            if let item = a.tabViewItems.first(where: { $0.viewController is ShortcutsPaneController }) {
                if let vc = item.viewController as? ShortcutsPaneController {
                    vc.names = actionItems()
                }
            }
            if let item = a.tabViewItems.first(where: { $0.viewController is InformationPaneController }) {
                if let vc = item.viewController as? InformationPaneController {
                    vc.mac2ios = self.iosListener
                }
            }
        }
        windowController.showWindow(nil)
        self.bringToFront()
    }
    
    @IBAction func openHomeApp(sender: NSButton) {
        if #available(macOS 10.15, *) {
            if let url = NSWorkspace.shared.urlForApplication(withBundleIdentifier: "com.apple.Home") {
                NSWorkspace.shared.open([], withApplicationAt: url, configuration: NSWorkspace.OpenConfiguration())
            }
        } else {
            // Fallback on earlier versions
            NSWorkspace.shared.launchApplication("Home")
        }
    }
    
    @IBAction func about(sender: NSButton) {
        self.iosListener?.openAbout()
    }
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}

