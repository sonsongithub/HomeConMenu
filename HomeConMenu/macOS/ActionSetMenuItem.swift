//
//  ActionSetMenuItem.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/05/06.
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

class ActionSetMenuItem: NSMenuItem, MenuItemFromUUID {
    let uniqueIdentifier: UUID
    let actionUniqueIdentifiers: [UUID]
    var mac2ios: mac2iOS?
    
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
    
    func update(enable: Bool) {
        guard let mac2ios = mac2ios else { return }
        do {
            let targetValues = try mac2ios.getTargetValues(of: uniqueIdentifier)
            let currentValues = try actionUniqueIdentifiers.map { uuid in
                return try mac2ios.getCharacteristic(of: uuid)
            }
            guard targetValues.count == currentValues.count else { throw NSError(domain: "com.sonson.HomeConMenu.macOS", code: 4)}
            
            let check = zip(targetValues, currentValues).reduce(true) { partialResult, tuple in
                switch tuple {
                case (let a as Int, let b as Int):
                    return partialResult && (a == b)
                case (let a as Double, let b as Double):
                    return partialResult && (a == b)
                default:
                    return false
                }
            }
            state = check ? .on : .off
        } catch {
            print(error)
        }
    }

    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.uniqueIdentifier = UUID()
        self.actionUniqueIdentifiers = []
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func execute(sender: NSMenuItem) {
        if let mac2ios = mac2ios {
            mac2ios.executeActionSet(uniqueIdentifier: uniqueIdentifier)
        }
    }
    
    init(actionSetInfo: ActionSetInfoProtocol, mac2ios: mac2iOS?) {
        self.uniqueIdentifier = actionSetInfo.uniqueIdentifier
        self.mac2ios = mac2ios
        self.actionUniqueIdentifiers = actionSetInfo.actionUniqueIdentifiers
        super.init(title: actionSetInfo.name, action: nil, keyEquivalent: "")
        self.action = #selector(self.execute(sender:))
        self.target = self
    }
}
