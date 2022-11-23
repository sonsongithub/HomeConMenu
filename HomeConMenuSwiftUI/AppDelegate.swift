//
//  AppDelegate.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/09.
//

import Foundation
import os
import AppKit


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

class AppDelegate : NSObject, NSApplicationDelegate {
    
    let mainMenu = NSMenu()
    var statusItem: NSStatusItem?
    
    func runBaseCatalystApp() {
        let workspace = NSWorkspace.shared
        let applicationURL = workspace.urlForApplication(withBundleIdentifier: "com.sonson.HomeConMenu.macOS")!
        
        if let _ = workspace.runningApplications.firstIndex(where: { application in
            application.bundleIdentifier == "com.sonson.HomeConMenu.macOS"
        }) {
            return
        }
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.createsNewApplicationInstance = true
        configuration.arguments = []
        NSWorkspace.shared.openApplication(at: applicationURL, configuration: configuration)
    }
    
    func postNotificationToTerminateCatalystApp() {
        DistributedNotificationCenter.default().postNotificationName(.terminate_iOSNotification, object: nil, deliverImmediately: true)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
#if DEBUG
        postNotificationToTerminateCatalystApp()
#endif
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        if let button = self.statusItem!.button {
            button.image = NSImage.init(systemSymbolName: "wrench.and.screwdriver", accessibilityDescription: nil)
        }
        self.statusItem!.menu = mainMenu
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(didReceiveAllUpdateNotification), name: .didUpdateAllItems, object: nil)
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(didReceiveCharacateristicUpdate), name: .didUpdateCharacteristic, object: nil)
        
#if DEBUG
        runBaseCatalystApp()
#endif
    }
    
    func updateMenuItem(with characteristic: HCCharacteristic) {

        let items = NSMenu.getSubItems(menu: mainMenu)
            .compactMap({ $0 as? MenuItemFromUUID })
            .compactMap({ $0 })
            .filter ({ item in
                item.bind(with: characteristic.uniqueIdentifier)
            })
        
        items.forEach { item in
            switch item {
            case let menuItem as LightColorMenuItem:
                if let temp = characteristic.doubleValue {
                    menuItem.update(of: characteristic.uniqueIdentifier, value: temp)
                }
            case let menuItem as ToggleMenuItem:
                if let temp = characteristic.doubleValue {
                    menuItem.update(value: temp > 0)
                }
                menuItem.reachable = characteristic.reachable
            default:
                do {}
            }
        }
    }
    
    func updateAllMenuItems(with communication: HCCommunication) {
        mainMenu.removeAllItems()
        
        communication.rooms.forEach { room in
            let sub = NSMenuItem(title: room.roomName, action: nil, keyEquivalent: "")
            mainMenu.addItem(sub)
            
            communication.accessories(in: room).forEach { accessory in
                accessory.serivces.forEach { service in
                    if let item = SensorMenuItem(service: service) {
                        mainMenu.addItem(item)
                    }
                    if service.type == .switch {
                        if let item = SwitchMenuItem(service: service) {
                            mainMenu.addItem(item)
                        }
                    }
                    if service.type == .outlet {
                        if let item = OutletMenuItem(service: service) {
                            mainMenu.addItem(item)
                        }
                    }
                    if service.type == .lightbulb {
                        if let item = LightbulbMenuItem(service: service) {
                            mainMenu.addItem(item)
                        }
                    }
                }
            }
            
            mainMenu.addItem(NSMenuItem.separator())
        }
        
    }
    
    @objc func didReceiveCharacateristicUpdate(_ notification: Notification) {
        do {
            guard let stringJson = notification.object as? String else { throw HomeConMenuError.distributedNotificationHasNoString }
            guard let data = stringJson.data(using: .utf8) else { throw HomeConMenuError.stringCannotBeConvertedToData }
            let decoder = JSONDecoder()
            let characteristic = try decoder.decode(HCCharacteristic.self, from: data)
            updateMenuItem(with: characteristic)
        } catch {
            print(error)
        }
    }
    
    @objc func didReceiveAllUpdateNotification(_ notification: Notification) {
       
        do {
            guard let stringJson = notification.object as? String else { throw HomeConMenuError.distributedNotificationHasNoString }
            guard let data = stringJson.data(using: .utf8) else { throw HomeConMenuError.stringCannotBeConvertedToData }
            let decoder = JSONDecoder()
            let communication = try decoder.decode(HCCommunication.self, from: data)
            updateAllMenuItems(with: communication)
        } catch {
            print(error)
        }
        
    }
}
