//
//  PowerMenu.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/11/20.
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

import Cocoa
import os

class ToggleMenuItem: NSMenuItem, MenuItemFromUUID, ErrorMenuItem {//}, MenuItemFromUUID, ErrorMenuItem, MenuItemOrder {
    
    var orderPriority: Int {
        100
    }
    
    var reachable: Bool = false {
        didSet {
            if reachable {
                self.target = self
                self.image = icon
            } else {
                self.target = nil
                self.image = NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
            }
        }
    }
    
    func UUIDs() -> [UUID] {
        return characteristicIdentifiers
    }
    
    var icon: NSImage? {
        return NSImage(systemSymbolName: "powerplug", accessibilityDescription: nil)
    }
    
    func bind(with uniqueIdentifier: UUID) -> Bool {
        return characteristicIdentifiers.contains(where: { $0 == uniqueIdentifier })
    }
    
    let characteristicIdentifiers: [UUID]
    
    @IBAction func toggle(sender: NSMenuItem) {
        guard let uuid = characteristicIdentifiers.first else { return }
        do {
            
            let characteristic = HCCharacteristic(uuid: uuid)
            
            if self.state == .on {
                characteristic.doubleValue = 0
                self.state = .off
            } else {
                characteristic.doubleValue = 1
                self.state = .on
            }

            let encoder = JSONEncoder()
            let data = try encoder.encode(characteristic)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "", code: 0)
            }
            DistributedNotificationCenter.default().postNotificationName(.to_iosNotification, object: jsonString, deliverImmediately: true)
        } catch {
            Logger.app.error("\(error.localizedDescription)")
        }
    }
    
    func update(value: Bool) {
//        reachable = true
        self.state = value ? .on : .off
    }
                
    init?(service: HCService) {
        guard let powerStateChara = service.characteristics.first(where: { obj in
            obj.type == .powerState
        }) else { return nil }
        
        
        self.characteristicIdentifiers = [powerStateChara.uniqueIdentifier]
        super.init(title: service.serviceName, action: nil, keyEquivalent: "")
        
        if let number = powerStateChara.doubleValue {
            self.state = (number > 0) ? .on : .off
        }
        
        self.reachable = powerStateChara.reachable
        
        if reachable {
            self.image = icon
        } else {
            self.image = NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
        }
        self.action = #selector(self.toggle(sender:))
//        self.target = self
    }
    
    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.characteristicIdentifiers = []
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SwitchMenuItem: ToggleMenuItem {
    override var icon: NSImage? {
        return NSImage(systemSymbolName: "switch.2", accessibilityDescription: nil)
    }
}

class OutletMenuItem: ToggleMenuItem {
    override var icon: NSImage? {
        return NSImage(systemSymbolName: "powerplug", accessibilityDescription: nil)
    }
}
