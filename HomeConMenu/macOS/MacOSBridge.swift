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
            item as? MenuFromUUID
        }).map({ item in
            item.UUIDs()
        }).flatMap({$0})
        iosListener?.reload(uniqueIdentifiers: uuids)
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
            if let url = URL(string: "x-apple.systempreferences:com.apple.preference.security?Privacy_HomeKit") {
                NSWorkspace.shared.open(url)
            }
            return true
        default:
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
        
        guard let item = mainMenu.items.compactMap({ item in
            item as? MenuFromUUID
        }).filter ({ item in
            item.bind(with: chracteristicInfo.uniqueIdentifier)
        }).first else { return }
        
        switch (item, chracteristicInfo.value, chracteristicInfo.type) {
        case (let item as LightColorMenu, let value as CGFloat, .hue):
            item.update(hueFromHMKit: value, saturationFromHMKit: nil, brightnessFromHMKit: nil)
            item.isEnabled = chracteristicInfo.enable
        case (let item as LightColorMenu, let value as CGFloat, .saturation):
            item.update(hueFromHMKit: nil, saturationFromHMKit: value, brightnessFromHMKit: nil)
            item.isEnabled = chracteristicInfo.enable
        case (let item as LightColorMenu, let value as CGFloat, .brightness):
            item.update(hueFromHMKit: nil, saturationFromHMKit: nil, brightnessFromHMKit: value)
            item.isEnabled = chracteristicInfo.enable
        case (let item as PowerMenu, let value as Int, _):
            item.update(value: value)
            item.isEnabled = chracteristicInfo.enable
        case (let item as SensorMenu, let value, _):
            item.update(value: value)
            item.isEnabled = false
        default:
            do {}
        }
    }
    
    func didUpdate() {
        mainMenu.removeAllItems()
        guard let infoArray = self.iosListener?.getArray() else { return }
        
        for info in infoArray {
            var items: [NSMenuItem?] = []
            
            items.append(CameraMenu(accessoryInfo: info, mac2ios: iosListener))
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
        
        if mainMenu.items.count == 0 {
            UserDefaults.standard.set(false, forKey: "doesNotShowLaunchViewController")
            UserDefaults.standard.synchronize()
        }
        
        let abouItem = NSMenuItem()
        abouItem.title = "About HomeConMenu"
        abouItem.action = #selector(MacOSBridge.about(sender:))
        abouItem.target = self
        mainMenu.addItem(abouItem)
        
        mainMenu.addItem(NSMenuItem.separator())
        
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
    
    @IBAction func about(sender: NSButton) {
        self.iosListener?.openAbout()
    }
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}

