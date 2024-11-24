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



enum MusicStatus {
    case unknown
    case running
    case quit
}

class MacOSController: NSObject, iOS2Mac, NSMenuDelegate {
    let mainMenu = NSMenu()
    var iosListener: mac2iOS?
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    
    let airPlayMenu = NSMenu()
    
    lazy var settingsWindowController = SettingsWindowController()
    lazy var launchWindowController = LaunchWindowController()

    var isMusicAppRunning = false
    
    var musicStatus = MusicStatus.unknown
    
    required override init() {
        super.init()
        
        if let button = self.statusItem.button {
            button.image = NSImage.init(systemSymbolName: "house", accessibilityDescription: nil)
        }
        self.statusItem.menu = mainMenu
        mainMenu.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeUserDefaults), name: UserDefaults.didChangeNotification, object: nil)
        // NSWorkspace.shared.notificationCenter.addObserver(self, selector: #selector(self.didAwakeSleep), name: NSWorkspace.didWakeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.windowWillClose(notification:)), name: NSWindow.willCloseNotification, object: nil)
        
        mainMenu.delegate = self
        
        // Create invisible window that's always on-screen
        // Allows using keyboard shortcuts even when menubar is hidden
        let alwaysPresentWindow = NSWindow()
        alwaysPresentWindow.styleMask = [.borderless]
        alwaysPresentWindow.collectionBehavior = [
            .canJoinAllSpaces,
            .fullScreenAuxiliary,
            .ignoresCycle,
            .transient
        ]
        alwaysPresentWindow.setFrame(.zero, display: true)
        alwaysPresentWindow.orderFront(self)
    }
    
    /// Collect and returns a collection of ShortcutInfo that is fetched from HomeKit.
    /// The returning ShortcutInfo array is passed to SettingsViewController.
    /// - Returns: ShortcutInfo array
    func shortcuts() -> [ShortcutInfo] {
        
        var infoArray: [ShortcutInfo] = []
        
//        if let serviceGroups = self.iosListener?.serviceGroups {
//            names.append(contentsOf: serviceGroups.map({ $0.name }))
//        }
        
        infoArray.append(.musicPlay)
        infoArray.append(.musicForward)
        infoArray.append(.musicBackward)
        
        if let actionSets = self.iosListener?.actionSets {
            infoArray.append(contentsOf: actionSets.map({ ShortcutInfo.home(name: $0.name, uniqueIdentifier: $0.uniqueIdentifier) }))
        }
        
        if let accessories = self.iosListener?.accessories {
            for info in accessories {
                info.services.forEach { serviceInfo in
                    switch serviceInfo.type {
                    case .lightbulb:
                        infoArray.append(ShortcutInfo.lightbulb(name: serviceInfo.name, uniqueIdentifier: serviceInfo.uniqueIdentifier))
                    case .outlet:
                        infoArray.append(ShortcutInfo.outlet(name: serviceInfo.name, uniqueIdentifier: serviceInfo.uniqueIdentifier))
                    case .switch:
                        infoArray.append(ShortcutInfo.switch(name: serviceInfo.name, uniqueIdentifier: serviceInfo.uniqueIdentifier))
                    default:
                        do {}
                    }
                }
            }
        }
        return infoArray
    }
    
    func getExcludedServiceUUIDs() -> [UUID] {
        guard let serviceGroups = self.iosListener?.serviceGroups else { return [] }
        return serviceGroups.compactMap({ $0.services }).flatMap({$0}).map({$0.uniqueIdentifier})
    }
    
    // MARK: - NSMenuDelegate
    
    
    func menuWillOpen(_ menu: NSMenu) {
        if menu == mainMenu {
            let items = NSMenu.getSubItems(menu: menu)
                .compactMap({ $0 as? ErrorMenuItem})
                .compactMap({ $0 as? MenuItemFromUUID })
                .compactMap({ $0.UUIDs() })
                .flatMap({ $0 })
            
            for uniqueIdentifider in items {
                iosListener?.readCharacteristic(of: uniqueIdentifider)
            }
            
            let musicIsRunning = NSWorkspace.shared.runningApplications.contains(where: { $0.bundleIdentifier == "com.apple.Music" })
            
            switch (musicStatus, musicIsRunning) {
            case (.unknown, true):
                musicStatus = .running
                // must reload
                reloadMenuExtra()
            case (.unknown, false):
                musicStatus = .quit
                reloadMenuExtra()
            case (.running, false):
                musicStatus = .quit
                reloadMenuExtra()
            case (.running, true):
                musicStatus = .running
                // not reload
            case (.quit, false):
                musicStatus = .quit
                // not reload
            case (.quit, true):
                musicStatus = .running
                reloadMenuExtra()
            }
            self.reloadAirPlayMenu()
        }
        if menu == airPlayMenu {
            self.updateAirPlayMenu()
        }
    }
    
    func menuDidClose(_ menu: NSMenu) {
        if menu == mainMenu {
            if NSWorkspace.shared.runningApplications.contains(where: { $0.bundleIdentifier == "com.apple.Music" }) {
                musicStatus = .running
            } else {
                musicStatus = .quit
            }
        }
    }
    
    // MARK: - Reload menu items
    
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
    
    @MainActor
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
    
    @MainActor
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
            if buffer.count > 0 {
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
    
    @MainActor
    func reloadNoRoomAccessories(excludedServiceUUIDs: [UUID]) {
        guard let accessories = self.iosListener?.accessories else { return }
        guard let rooms = self.iosListener?.rooms else { return }
        
        let allowDuplicatingServices = UserDefaults.standard.bool(forKey: "allowDuplicatingServices")
        
        var noRoomAccessories: [NSMenuItem] = []
        
        let roomIdentifiers = rooms.compactMap({ $0.uniqueIdentifier })
        for info in accessories {
            
            if let theRoom = info.room {
                if roomIdentifiers.firstIndex(of: theRoom.uniqueIdentifier) == nil {
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
                    noRoomAccessories.append(contentsOf: candidates)
                }
            }
        }
        if noRoomAccessories.count > 0 {
            for menuItem in noRoomAccessories {
                mainMenu.addItem(menuItem)
            }
            mainMenu.addItem(NSMenuItem.separator())
        }
    }
    
    func reloadOtherItems() {
        let abouItem = NSMenuItem()
        abouItem.title = NSLocalizedString("About HomeConMenu", comment: "")
        abouItem.action = #selector(MacOSController.about(sender:))
        abouItem.target = self
        mainMenu.addItem(abouItem)
        
        let prefItem = NSMenuItem()
        prefItem.title = NSLocalizedString("Settings…", comment: "")
        prefItem.action = #selector(MacOSController.preferences(sender:))
        prefItem.target = self
        mainMenu.addItem(prefItem)
        
        mainMenu.addItem(NSMenuItem.separator())
        
        let menuItem = NSMenuItem()
        menuItem.title = NSLocalizedString("Quit HomeConMenu", comment: "")
        menuItem.action = #selector(MacOSController.quit(sender:))
        menuItem.target = self
        mainMenu.addItem(menuItem)
    }
    
    let musicPlayMenu = NSMenu()
    
    func reloadMusicAppMenuItems() {
        guard UserDefaults.standard.bool(forKey: "musicControllerShows") else { return }
       
        guard musicStatus == .running else { return }
        
        let musicItem = NSMenuItem()
        musicItem.title = NSLocalizedString("Music", comment: "Music app")
        musicItem.submenu = musicPlayMenu
        musicItem.image = NSImage(systemSymbolName: "music.note", accessibilityDescription: nil)
        mainMenu.addItem(musicItem)
        let isMusicAppRunning = NSWorkspace.shared.runningApplications.contains(where: { $0.bundleIdentifier == "com.apple.Music" })
        let playerItem = NSMenuItem()

        let v = MusicPlayerView.create(frame: NSRect(x: 0, y: 0, width: 240, height: 90))
        playerItem.view = v
        v?.update()
        v?.showUI(isMusicAppRunning: isMusicAppRunning)
        mainMenu.addItem(playerItem)
        
        musicPlayMenu.removeAllItems()
        let v2 = MusicTrackView.create(frame: NSRect(x: 0, y: 0, width: 30, height: 30))
        let trackItem = NSMenuItem()
        trackItem.view = v2
        musicPlayMenu.addItem(trackItem)
        
        let item = NSMenuItem(title: "AirPlay", action: nil, keyEquivalent: "")
        item.image = NSImage(systemSymbolName: "airplayaudio", accessibilityDescription: nil)
        item.submenu = airPlayMenu
        mainMenu.addItem(item)
        mainMenu.addItem(NSMenuItem.separator())
    }
    
    func reloadHomeKitMenuItems() {
        
        var items: [NSMenuItem] = []
        
        if let value = UserDefaults.standard.object(forKey: "showReloadMenuItem") as? Bool {
            if value {
                let reloadItem = NSMenuItem()
                reloadItem.title = NSLocalizedString("Reload", comment: "")
                reloadItem.action = #selector(MacOSController.reload(sender:))
                reloadItem.target = self
                reloadItem.image = NSImage(systemSymbolName: "arrow.clockwise", accessibilityDescription: nil)
                items.append(reloadItem)
            }
        }
        
        if let value = UserDefaults.standard.object(forKey: "showHomeAppMenuItem") as? Bool {
            if value {
                let openHomeItem = NSMenuItem()
                openHomeItem.title = NSLocalizedString("Open Home.app", comment: "")
                openHomeItem.action = #selector(MacOSController.openHomeApp(sender:))
                openHomeItem.target = self
                openHomeItem.image = NSImage(systemSymbolName: "homekit", accessibilityDescription: nil)
                items.append(openHomeItem)
            }
        }
        
        if items.count > 0 {
            items.forEach({mainMenu.addItem($0)})
            mainMenu.addItem(NSMenuItem.separator())
        }
    }
    
    func reloadHomeMenuItems() {
        guard let homes = iosListener?.homes else { return }
        guard let homeUniqueIdentifier = iosListener?.homeUniqueIdentifier else { return }
        guard homes.count > 1 || UserDefaults.standard.bool(forKey: "alwaysShowHomeItemOnMenu") else { return }
        
        var items: [NSMenuItem] = []
        
        let item = NSMenuItem()
        item.title = NSLocalizedString("Home", comment: "Selected home")
        item.image = NSImage(systemSymbolName: "house", accessibilityDescription: nil)
        items.append(item)
    
        let selected = NSMenuItem()
        selected.title = "Unknown"
        
        if let obj = homes.first(where: { homeInfo in
            return homeInfo.uniqueIdentifier == homeUniqueIdentifier
        }) {
            if let name = obj.name {
                selected.title = name
            }
        }
        
        let menu = NSMenu()
        selected.submenu = menu
        items.append(selected)
        
        homes.forEach { homeInfo in
            if let name = homeInfo.name, let uniqueIdentifier = homeInfo.uniqueIdentifier {
                let item = HomeSelectMenuItem(uniqueIdentifier: uniqueIdentifier)
                item.title = name
                menu.items.append(item)
                item.action = #selector(MacOSController.selectHome(sender:))
                item.target = self
            }
        }
        
        if items.count > 0 {
            items.forEach({mainMenu.addItem($0)})
            mainMenu.addItem(NSMenuItem.separator())
        }
    }
    
    func reloadAirPlayMenu() {
        Task {
            let devices = SBApplication.getCurrentAirPlayDevices()
            DispatchQueue.main.async {
                self.airPlayMenu.removeAllItems()
                devices.forEach { device in
                    let item = NSMenuItem()
                    item.title = device.name
                    let v = AirPlayDeviceView.create(frame: NSRect(x: 0, y: 0, width: 200, height: 50), name: device.name)
                    item.view = v
                    v?.icon?.image = device.kind.icon
                    v?.deviceNameLabel?.stringValue = device.name
                    v?.update()
                    self.airPlayMenu.addItem(item)
                }
            }
        }
    }
    
    func updateAirPlayMenu() {
        self.airPlayMenu.items.compactMap({ $0.view as? AirPlayDeviceView }).forEach { view in
            view.update()
        }
    }
    
    // MARK: - Notifications
    
    @IBAction func windowWillClose(notification: Notification) {
        if let window = notification.object as? NSWindow {
            let name = "\(type(of :window))"
            if name == "UINSWindow" {
                let uiWindows = window.value(forKeyPath: "uiWindows") as? [Any] ?? []
                Logger.app.info("will close UIWindow")
                Logger.app.info("\(uiWindows)")
                iosListener?.close(windows: uiWindows)
            }
        }
    }
    
    @IBAction func didChangeUserDefaults(notification: Notification) {
        reloadMenuExtra()
    }
    
    // MARK: - Actions
    
    @IBAction func selectHome(sender: HomeSelectMenuItem) {
        iosListener?.homeUniqueIdentifier = sender.uniqueIdentifier
        iosListener?.rebootHomeManager()
    }
    
    @IBAction func preferences(sender: NSButton?) {
        if let a = settingsWindowController.settingsTabViewController {
            if let item = a.tabViewItems.first(where: { $0.viewController is ShortcutsPaneController }) {
                if let vc = item.viewController as? ShortcutsPaneController {
                    vc.shortcutLabels = shortcuts()
                }
            }
            if let item = a.tabViewItems.first(where: { $0.viewController is InformationPaneController }) {
                if let vc = item.viewController as? InformationPaneController {
                    vc.mac2ios = self.iosListener
                }
            }
        }
        settingsWindowController.showWindow(nil)
        centeringWindows()
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
        launchWindowController.showWindow(sender)
        centeringWindows()
        self.bringToFront()
    }
    
    @IBAction func reload(sender: NSButton) {
        iosListener?.rebootHomeManager()
    }
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}

