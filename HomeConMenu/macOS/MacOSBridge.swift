//
//  MacOSBridge.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/02.
//

import Foundation
import AppKit

class MacOSBridge: NSObject, iOS2Mac, NSMenuDelegate {
    
    let mainMenu = NSMenu()
    var iosListener: mac2iOS?
    let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        
    func menuWillOpen(_ menu: NSMenu) {
        let uuids = mainMenu.items.compactMap({ item in
            item as? MenuItemFromUUID
        }).map({ item in
            item.UUIDs()
        }).flatMap({$0})
        iosListener?.reload(uniqueIdentifiers: uuids)
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
        
        // まずここで候補のメニューアイテムを全部列挙する
        guard let item = mainMenu.items.compactMap({ item in
            item as? MenuItemFromUUID
        }).filter ({ item in
            item.bind(with: chracteristicInfo.uniqueIdentifier)
        }).first else { return }
        
        // forで全部のmenuitemに更新を適応
        switch (item, chracteristicInfo.value, chracteristicInfo.type) {
        case (let item as LightColorMenuItem, let value as CGFloat, .hue):
            item.update(hueFromHMKit: value, saturationFromHMKit: nil, brightnessFromHMKit: nil)
            item.isEnabled = chracteristicInfo.enable
        case (let item as LightColorMenuItem, let value as CGFloat, .saturation):
            item.update(hueFromHMKit: nil, saturationFromHMKit: value, brightnessFromHMKit: nil)
            item.isEnabled = chracteristicInfo.enable
        case (let item as LightColorMenuItem, let value as CGFloat, .brightness):
            item.update(hueFromHMKit: nil, saturationFromHMKit: nil, brightnessFromHMKit: value)
            item.isEnabled = chracteristicInfo.enable
        case (let item as PowerMenuItem, let value as Int, _):
            item.update(value: value)
            item.isEnabled = chracteristicInfo.enable
        case (let item as SensorMenuItem, let value, _):
            item.update(value: value)
            item.isEnabled = false
        default:
            do {}
        }
    }
    
    func didUpdate2() {
        mainMenu.removeAllItems()
        guard let accessories = self.iosListener?.accessories else { return }
        guard let serviceGroups = self.iosListener?.serviceGroups else { return }
        guard let rooms = self.iosListener?.rooms else { return }
        
        for info in accessories {
            var items: [NSMenuItem?] = []
            
            items.append(CameraMenuItem(accessoryInfo: info, mac2ios: iosListener))
            items.append(contentsOf: info.services.map { serviceInfo in
                NSMenuItem.HomeMenus(accessoryInfo: info, serviceInfo: serviceInfo, mac2ios: iosListener)
            }.flatMap({$0}))
            
            var candidates = items.compactMap({$0})
            
            if candidates.count > 0 {
                let menuItem = NSMenuItem()
                menuItem.isEnabled = false
                menuItem.title = info.name ?? ""
                candidates.insert(menuItem, at: 0)
                for item in candidates {
                    mainMenu.addItem(item)
                }
                mainMenu.addItem(NSMenuItem.separator())
            }
            
        }
        
        let menuItem = NSMenuItem()
        menuItem.title = "Quit"
        menuItem.action = #selector(MacOSBridge.quit(sender:))
        menuItem.target = self
        mainMenu.addItem(menuItem)
    }
    
    func didUpdate() {
        mainMenu.removeAllItems()
        guard let accessories = self.iosListener?.accessories else { return }
        guard let serviceGroups = self.iosListener?.serviceGroups else { return }
        guard let rooms = self.iosListener?.rooms else { return }
        
        // group
        for serviceGroup in serviceGroups {
            for service in serviceGroup.services {
                print(service.name)
                print(service.type)
                print(service.characteristics)
            }
        }
        
        // room
        for room in rooms {
            let roomNameItem = NSMenuItem()
            roomNameItem.title = room.name ?? ""
            mainMenu.addItem(roomNameItem)
            for info in accessories {
                if info.room?.uniqueIdentifier == room.uniqueIdentifier {
                    var items: [NSMenuItem?] = []
                    
                    items.append(CameraMenuItem(accessoryInfo: info, mac2ios: iosListener))
                    items.append(contentsOf: info.services.map { serviceInfo in
                        NSMenuItem.HomeMenus(accessoryInfo: info, serviceInfo: serviceInfo, mac2ios: iosListener)
                    }.flatMap({$0}))
                    
                    var candidates = items.compactMap({$0})
                    for item in candidates {
                        mainMenu.addItem(item)
                    }
                }
            }
            mainMenu.addItem(NSMenuItem.separator())
        }
        
        
        let menuItem = NSMenuItem()
        menuItem.title = "Quit HomeConMenu"
        menuItem.action = #selector(MacOSBridge.quit(sender:))
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
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}

