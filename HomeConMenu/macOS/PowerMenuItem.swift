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

class PowerMenuItem: NSMenuItem, MenuItemFromUUID {
    func UUIDs() -> [UUID] {
        return [powerCharacteristicIdentifier]
    }
    
    func bind(with uniqueIdentifier: UUID) -> Bool {
        return powerCharacteristicIdentifier == uniqueIdentifier
    }
    
    let powerCharacteristicIdentifier: UUID
    var mac2ios: mac2iOS?
    
    @IBAction func toggle(sender: NSMenuItem) {
        self.mac2ios?.toggleValue(uniqueIdentifier: powerCharacteristicIdentifier)
        self.state = (self.state == .on) ? .off : .on
    }
    
    func update(value: Int) {
        self.state = (value == 1) ? .on : .off
    }
        
    init?(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        //mac2ios: mac2iOS?, title: Any?, uniqueIdentifier: UUID, state: Any?, type: ServiceType) {
        guard let powerStateChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .powerState
        }) else { return nil }
        
        self.mac2ios = mac2ios
        self.powerCharacteristicIdentifier = powerStateChara.uniqueIdentifier
        super.init(title: serviceInfo.name, action: nil, keyEquivalent: "")
        
        if let number = powerStateChara.value as? Int {
            self.state = (number == 0) ? .off : .on
        }
        if serviceInfo.type == .switch {
            self.image = NSImage(systemSymbolName: "switch.2", accessibilityDescription: nil)
        } else {
            self.image = NSImage(systemSymbolName: "powerplug", accessibilityDescription: nil)
        }

        self.action = #selector(PowerMenuItem.toggle(sender:))
        self.target = self
    }
    
    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.powerCharacteristicIdentifier = UUID()
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
