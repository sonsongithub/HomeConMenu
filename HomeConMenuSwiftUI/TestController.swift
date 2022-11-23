//
//  TestController.swift
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


class TestController : NSObject, NSApplicationDelegate {
    
    let mainMenu = NSMenu()
    var statusItem: NSStatusItem?
    
    func applicationWillTerminate(_ notification: Notification) {
#if DEBUG
        DistributedNotificationCenter.default().postNotificationName(.terminate_iOSNotification, object: nil, deliverImmediately: true)
#endif
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        if let button = self.statusItem!.button {
            button.image = NSImage.init(systemSymbolName: "wrench.and.screwdriver", accessibilityDescription: nil)
        }
        self.statusItem!.menu = mainMenu
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(fromMacNotification), name: .to_macNotification, object: nil)
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(to_char_notify), name: .to_char_notify, object: nil)
        
#if DEBUG
        let workspace = NSWorkspace.shared
        let applicationURL = workspace.urlForApplication(withBundleIdentifier: "com.sonson.HomeConMenu.macOS")!
        
        if let _ = workspace.runningApplications.firstIndex { application in
            application.bundleIdentifier == "com.sonson.HomeConMenu.macOS"
        } {
            return
        }
        
        
        let configuration = NSWorkspace.OpenConfiguration()
        configuration.createsNewApplicationInstance = true
        configuration.arguments = []
        NSWorkspace.shared.openApplication(at: applicationURL, configuration: configuration)
#endif
    }
    
    @objc func to_char_notify(_ notification: Notification) {
        print(#function)
        guard let stringJson = notification.object as? String else {
            return
        }
        guard let data = stringJson.data(using: .utf8) else {
            return
        }
        let decoder = JSONDecoder()
        do {
            let obj = try decoder.decode(HCCharacteristic.self, from: data)
            
            let items = NSMenu.getSubItems(menu: mainMenu)
                .compactMap({ $0 as? MenuItemFromUUID })
                .compactMap({ $0 })
                .filter ({ item in
                    item.bind(with: obj.uniqueIdentifier)
                })
            
            items.forEach { item in
                switch item {
                case let menuItem as LightColorMenuItem:
                    if let temp = obj.doubleValue {
                        menuItem.update(of: obj.uniqueIdentifier, value: temp)
                    }
                case let menuItem as ToggleMenuItem:
                    if let temp = obj.doubleValue {
                        menuItem.update(value: temp > 0)
                    }
                    menuItem.reachable = obj.reachable
                default:
                    do {}
                }
            }
            
        } catch {
            print(error)
        }
        
    }
    
    @objc func fromMacNotification(_ notification: Notification) {
        print("a")
        print(#function)
        let obj = notification.object
        print(obj)
        
        let decoder = JSONDecoder()
        
        guard let stringJson = notification.object as? String else {
            return
        }
        
        guard let data = stringJson.data(using: .utf8) else {
            return
        }
        
        do {
            let obj = try decoder.decode(HCCommunication.self, from: data)
            print(obj)
            
            mainMenu.removeAllItems()
            
            obj.rooms.forEach { room in
                let sub = NSMenuItem(title: room.roomName, action: nil, keyEquivalent: "")
                mainMenu.addItem(sub)
                
                obj.accessories(in: room).forEach { accessory in
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
            
        } catch {
            print(error)
        }
        
    }
    
    override init() {
        super.init()
        
        
    }
}
