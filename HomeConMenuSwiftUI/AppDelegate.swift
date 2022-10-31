//
//  AppDelegate.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/28.
//

import Foundation
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, ObservableObject {
    var statusItem: NSStatusItem!
    let mainMenu = NSMenu()
    
    var menuView: MenuView?
        
    
    @objc func receive_chara(_ notification: Notification) {
        
        let decoder = JSONDecoder()
        
        guard let stringJson = notification.object as? String else {
            return
        }
        
        guard let data = stringJson.data(using: .utf8) else {
            return
        }
        
        do {
            let temp = try decoder.decode(HCCharacteristic.self, from: data)
            
            if let data = menuView?.data {
                for i in 0..<data.rooms.count {
                    for j in 0..<data.rooms[i].accessories.count {
                        for k in 0..<data.rooms[i].accessories[j].charateristics.count {
                            if temp.uniqueIdentifier == data.rooms[i].accessories[j].charateristics[k].uniqueIdentifier {
                                switch data.rooms[i].accessories[j].charateristics[k] {
                                case var obj as SUSwitch:
                                    if let v = temp.numberValue {
                                        obj.status = (v > 0)
                                        data.dirty = true
                                    }
                                default:
                                    do {}
                                }
                            }
                        }
                    }
                }
            }
            
        } catch {
            print(error)
        }
        
//        do {
//            let temp = try decoder.decode(HCCharacteristic.self, from: data)
//
//            if let object = menuView?.object {
//                let services = object.accesories.map({$0.serivces}).flatMap({$0})
//                var characteristics = services.map({$0.characteristics}).flatMap({$0})
//                for i in (0..<characteristics.count) {
//                    if characteristics[i].uniqueIdentifier == temp.uniqueIdentifier {
//                        characteristics[i].intValue = temp.intValue
//                        characteristics[i].boolValue = temp.boolValue
//                        characteristics[i].doubleValue = temp.doubleValue
//                        characteristics[i].numberValue = temp.numberValue
//                    }
//                }
//            }
//        } catch {
//            print(error)
//        }
    }
    
    @objc func fromMacNotification(_ notification: Notification) {

        let decoder = JSONDecoder()
        
        guard let stringJson = notification.object as? String else {
            return
        }
        
        print(stringJson)
        
        guard let data = stringJson.data(using: .utf8) else {
            return
        }
        
        do {
            let temp = try decoder.decode(HCCommunication.self, from: data)
//            menuView?.object.accesories = temp.accessories
//            menuView?.object.rooms = temp.rooms
//
//            print(temp.accessories)
            
            if let data = menuView?.data {
                
                data.rooms = []
                
                temp.rooms.forEach { room in
                    var newRoom = SURoom(name: room.roomName)
                    temp.accessories.forEach { accessory in
                        if accessory.room?.uniqueIdentifier == room.uniqueIdentifier {
                            var newAccessory = SUAccessory(name: accessory.accessoryName, uniqueIdentifier: accessory.uniqueIdentifier)
                            newRoom.accessories.append(newAccessory)
                            
                            accessory.serivces.forEach { service in
                                service.characteristics.forEach { characteristic in
                                    print(characteristic.type)
                                    if characteristic.type == .currentTemperature {
                                        var newChara = SUTemperature(name: characteristic.type.description, uniqueIdentifier: characteristic.uniqueIdentifier)
                                        if let value = characteristic.doubleValue {
                                            newChara.temperature = value
                                        }
                                        newAccessory.charateristics.append(newChara)
                                    } else if characteristic.type == .powerState {
                                        var newChara = SUSwitch(name: "power", uniqueIdentifier: characteristic.uniqueIdentifier)
                                        print(characteristic.boolValue)
                                        if let value = characteristic.numberValue {
                                            newChara.status = (value > 0)
                                        }
                                        newAccessory.charateristics.append(newChara)
                                    } else {
                                            var newChara = SUCharateristic(name: characteristic.type.description, uniqueIdentifier: characteristic.uniqueIdentifier)
                                        newAccessory.charateristics.append(newChara)
                                    }
                                }
                            }
                        }
                    }
                    data.rooms.append(newRoom)
                }
            }
            
        } catch {
            print(error)
        }
    }
    
    override init() {
        super.init()
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(fromMacNotification), name: .to_macNotification, object: nil)
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(receive_chara), name: .to_char_notify, object: nil)
    }
    
    func applicationDidFinishLaunching(_ notification: Notification) {
//        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
//
//        let image = NSImage(systemSymbolName: "wrench.and.screwdriver", accessibilityDescription: "Some App's status menu")!
//        statusItem.button?.image = image
//
//        statusItem.menu = mainMenu
        
        print("A")
//
//        let menu = NSMenu()
//
//        let quitMenuItem = NSMenuItem.init(title: "Quit SomeAPp", action: #selector(quit), keyEquivalent: "q")
//        menu.addItem(quitMenuItem)
//
//        statusItem.menu = menu
    }

//    @objc func quit() {
//        print("quit")
//    }
}
