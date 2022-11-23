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

extension NSMenuItem {
//    class func HomeMenus(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) -> [NSMenuItem?] {
//        switch serviceInfo.type {
//        case .humiditySensor, .temperatureSensor:
//            return [SensorMenuItem(serviceInfo: serviceInfo, mac2ios: mac2ios)]
//        case .lightbulb:
//            return [LightbulbMenuItem(serviceInfo: serviceInfo, mac2ios: mac2ios)]
//        case .switch:
//            return [SwitchMenuItem(serviceInfo: serviceInfo, mac2ios: mac2ios)]
//        case .outlet:
//            return [OutletMenuItem(serviceInfo: serviceInfo, mac2ios: mac2ios)]
//        default:
//            return []
//        }
//    }
    
    class func HomeMenus(serviceGroup: HCServiceGroup) -> [NSMenuItem?] {
        
        let serviceTypes = Set(serviceGroup.services.map({ $0.type}))
        
        guard let firstService = serviceGroup.services.first else { return [] }
//
//        var buffer = Set(firstService.characteristics.map({ $0.type }))
//        for service in serviceGroup.services {
//            buffer = Set(service.characteristics.map({$0.type})).intersection(buffer)
//        }
        
        let buffer = serviceGroup.services.reduce(Set(firstService.characteristics.map({ $0.type }))) { partialResult, service in
            Set(service.characteristics.map({$0.type})).intersection(partialResult)
        }
        
        if buffer.contains(.powerState) && serviceTypes.contains(.outlet) {
            return [OutletMenuItem(serviceGroup: serviceGroup)]
        }
        if buffer.contains(.powerState) && serviceTypes.contains(.switch) {
            return [SwitchMenuItem(serviceGroup: serviceGroup)]
        }
        if buffer.contains(.powerState) && serviceTypes.contains(.lightbulb) {
            return [LightbulbMenuItem(serviceGroup: serviceGroup)]
        }
        return []
    }
}

class AppDelegate : NSObject, NSApplicationDelegate, NSMenuDelegate {
    
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
        DistributedNotificationCenter.default().postNotificationName(.requestTerminateIOSNotification, object: nil, deliverImmediately: true)
    }
    
    func applicationWillTerminate(_ notification: Notification) {
#if DEBUG
        postNotificationToTerminateCatalystApp()
#endif
    }
    
    func menuWillOpen(_ menu: NSMenu) {
        DistributedNotificationCenter.default().postNotificationName(.requestReloadHomeKitNotification, object: nil, deliverImmediately: true)
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        self.statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
        if let button = self.statusItem!.button {
            button.image = NSImage.init(systemSymbolName: "wrench.and.screwdriver", accessibilityDescription: nil)
        }
        self.statusItem!.menu = mainMenu
        mainMenu.delegate = self
        
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(didReceiveAllUpdateNotification), name: .didUpdateAllItems, object: nil)
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(didReceiveCharacateristicUpdate), name: .didUpdateCharacteristic, object: nil)
        
        
        
#if DEBUG
        runBaseCatalystApp()
#endif
    }
    
    func updateMenuItem(with characteristic: HCCharacteristic) {
        NSMenu.getSubItems(menu: mainMenu)
            .compactMap({ $0 as? MenuItemFromUUID })
            .compactMap({ $0 })
            .filter ({ item in
                item.bind(with: characteristic.uniqueIdentifier)
            })
            .compactMap({ $0 as? Updatable })
            .forEach({ $0.update(with: characteristic)})
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
        
        let serviceGroupItems = communication.serviceGroups.compactMap({ NSMenuItem.HomeMenus(serviceGroup: $0) }).flatMap({ $0 }).compactMap({$0})
        
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
        
        let menuItem = NSMenuItem()
        menuItem.title = NSLocalizedString("Quit HomeConMenu", comment: "")
        menuItem.action = #selector(AppDelegate.quit(sender:))
        menuItem.target = self
        mainMenu.addItem(menuItem)
        
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
    
    @IBAction func quit(sender: NSButton) {
        NSApplication.shared.terminate(self)
    }
}
