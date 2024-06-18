//
//  PowerMenu.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/20.
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
import KeyboardShortcuts

class ToggleMenuItem: NSMenuItem, MenuItemFromUUID, ErrorMenuItem, MenuItemOrder {
    
    let characteristicIdentifiers: [UUID]
    var mac2ios: mac2iOS?
    var icon: NSImage? {
        return NSImage(systemSymbolName: "powerplug", accessibilityDescription: nil)
    }
    
    init?(serviceGroupInfo: ServiceGroupInfoProtocol, mac2ios: mac2iOS?) {

        let characteristicInfos = serviceGroupInfo.services.map({ $0.characteristics }).flatMap({ $0 })
           
        let infos = characteristicInfos.filter({ $0.type == .powerState })
        
        guard infos.count > 0 else { return nil }
        
        guard let sample = infos.first else { return nil}
        
        
        let uuids = infos.map({$0.uniqueIdentifier})
        
        self.reachable = true
        self.mac2ios = mac2ios
        self.characteristicIdentifiers = uuids
        super.init(title: serviceGroupInfo.name, action: nil, keyEquivalent: "")

        if let number = sample.value as? Int {
            self.state = (number == 0) ? .off : .on
        }
        self.image = self.icon
        self.action = #selector(self.toggle(sender:))
        self.target = self
    }
        
    @MainActor
    init?(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        guard let powerStateChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .powerState
        }) else { return nil }
        self.reachable = true
        self.mac2ios = mac2ios
        self.characteristicIdentifiers = [powerStateChara.uniqueIdentifier]
        super.init(title: serviceInfo.name, action: nil, keyEquivalent: "")
        
        if let number = powerStateChara.value as? Int {
            self.state = (number == 0) ? .off : .on
        }
        self.image = self.icon
        self.action = #selector(self.toggle(sender:))
        self.target = self
        if let r = KeyboardShortcuts.Name(rawValue: serviceInfo.uniqueIdentifier.uuidString) {
            setShortcut(for: r)
            KeyboardShortcuts.onKeyDown(for: r, action: {
                self.toggle(sender: self)
            })
        }
    }
    
    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.characteristicIdentifiers = []
        self.reachable = true
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(value: Bool) {
        reachable = true
        self.state = value ? .on : .off
    }
    
    // MARK: - MenuItemProtocol
    
    func bind(with uniqueIdentifier: UUID) -> Bool {
        return characteristicIdentifiers.contains(where: { $0 == uniqueIdentifier })
    }
    
    var orderPriority: Int {
        100
    }
    
    var reachable: Bool {
        didSet {
            if reachable {
                self.image = icon
            } else {
                self.image = NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
            }
        }
    }
    
    func UUIDs() -> [UUID] {
        return characteristicIdentifiers
    }
    
    // MARK: - Aciton
    
    @IBAction func toggle(sender: NSMenuItem) {
        guard let uuid = characteristicIdentifiers.first else { return }
        do {
            let value = try self.mac2ios?.getCharacteristic(of: uuid)
            if let boolValue = value as? Bool {
                for uuid in characteristicIdentifiers {
                    self.mac2ios?.setCharacteristic(of: uuid, object: !boolValue)
                }
            }
        } catch let error as HomeConMenuError {
            Logger.app.error("\(error.localizedDescription)")
        } catch {
            Logger.app.error("Can not get toggle status, unexpected error - \(error.localizedDescription)")
        }
    }
}
