//
//  ActionSetMenuItem.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/11/23.
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

enum ActionSetMenuItemStatus {
    case executable
    case excecuted
    case disabled
}

class ActionSetMenuItem: NSMenuItem, MenuItemFromUUID, Updatable, ActionSetUpdatable {
    
    var status: ActionSetMenuItemStatus = .disabled {
        didSet {
            switch status {
            case .executable:
                self.target = self
                self.image = createImage(check: false)
            case .excecuted:
                self.target = nil
                self.image = createImage(check: true)
            case .disabled:
                self.target = nil
                self.image = NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
            }
        }
    }
    
    let uniqueIdentifier: UUID
    let actionUniqueIdentifiers: [UUID]
    
    var actionSet: HCActionSet
    var currentValues: [UUID:HCCharacteristic] = [:]
    
    func UUIDs() -> [UUID] {
        return [uniqueIdentifier] + actionUniqueIdentifiers
    }
    
    public enum SensorType {
        case temperature
        case humidity
        case unknown
    }
    
    func bind(with _uniqueIdentifier: UUID) -> Bool {
        return self.uniqueIdentifier == _uniqueIdentifier || actionUniqueIdentifiers.contains(_uniqueIdentifier)
    }
    
    func createImage(check: Bool) -> NSImage? {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 14, height: 14))
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if check {
            view.layer?.backgroundColor = CGColor(red: 247.0/255.0, green: 148.0/255.0, blue: 30.0/255.0, alpha: 1)
        } else {
            view.layer?.backgroundColor = CGColor.init(gray: 0.5, alpha: 1.0)
        }
        
        view.layer?.cornerRadius = 2
        
        let destinationSize = Double(14)
        
        guard let homeIcon = NSImage.init(systemSymbolName: "house", accessibilityDescription: nil) else { return nil }
        
        let image = NSImage(size: NSSize(width: destinationSize, height: destinationSize))
        
        let width = Double(homeIcon.size.width)
        let height = Double(homeIcon.size.height)
        
        let x = (destinationSize - width) / 2
        let y = (destinationSize - height) / 2
        
        image.lockFocus()
        guard let ctx = NSGraphicsContext.current?.cgContext else { return nil }
        
        view.layer?.render(in: ctx)
        let source = NSRect(origin: CGPoint.zero, size: homeIcon.size)
        
        let destination = NSRect(x: x, y: y, width: width, height: height)
        
        homeIcon.draw(in: destination, from: source, operation: .destinationIn, fraction: 1)
        image.unlockFocus()

        return image
    }
    
    func update() {
        do {
            
            print(actionUniqueIdentifiers.count)
            
            let temp = actionUniqueIdentifiers.compactMap({currentValues[$0]})
            
            print(actionSet.actionSetName)
            
            print(temp.count)
            print("temp = \(temp.count)")
            
            let temp2 = temp.filter({$0.reachable})
            
            print(temp2.count)
            print("temp2 = \(temp2.count)")
            
            let chars = actionUniqueIdentifiers.compactMap({currentValues[$0]}).filter({$0.reachable}).compactMap({$0.doubleValue})
            
            
            print("chars = \(chars.count)")
            
            print("targetValues = \(actionSet.targetValues)")
            
            guard actionSet.targetValues.count == chars.count else { throw HomeConMenuError.actionSetCharacteristicsCountError }
            
            let check = zip(chars, actionSet.targetValues).reduce(true) { partialResult, tuple in
                return partialResult && (tuple.0 == tuple.1)
            }
            
            status = check ? .excecuted : .executable
            
        } catch {
            print(error)
            print("a")
            status = .disabled
        }
    }
    
    func update(with actionSet: HCActionSet) {
        self.actionSet = actionSet
        update()
    }
    
    func update(with characteristic: HCCharacteristic) {
        currentValues[characteristic.uniqueIdentifier] = characteristic
        update()
    }
    
    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.uniqueIdentifier = UUID()
        self.actionUniqueIdentifiers = []
        self.actionSet = HCActionSet(actionSetName: "", uniqueIdentifier: UUID(), actionUniqueIdentifiers: [])
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func execute(sender: NSMenuItem) {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(actionSet)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "", code: 0)
            }
            DistributedNotificationCenter.default().postNotificationName(.requestExecuteActionSetNotification, object: jsonString, deliverImmediately: true)
//            try data_array.forEach { (uuid, value) in
//                let characteristic = HCCharacteristic(uuid: uuid)
//                characteristic.doubleValue = value
//                let encoder = JSONEncoder()
//                let data = try encoder.encode(characteristic)
//                guard let jsonString = String(data: data, encoding: .utf8) else {
//                    throw NSError(domain: "", code: 0)
//                }
//                DistributedNotificationCenter.default().postNotificationName(.to_iosNotification, object: jsonString, deliverImmediately: true)
//            }
        } catch {
            print(error)
        }
//        requestExecuteActionSetNotification
//        if let mac2ios = mac2ios {
//            mac2ios.executeActionSet(uniqueIdentifier: uniqueIdentifier)
//        }
    }
    
    init(actionSet: HCActionSet) {
        self.uniqueIdentifier = actionSet.uniqueIdentifier
        self.actionUniqueIdentifiers = actionSet.actionUniqueIdentifiers
        self.actionSet = actionSet
        super.init(title: actionSet.actionSetName, action: nil, keyEquivalent: "")
        self.action = #selector(self.execute(sender:))
//        self.target = self
    }
}
