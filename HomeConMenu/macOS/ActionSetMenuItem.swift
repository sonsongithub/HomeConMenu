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
    var mac2ios: mac2iOS?
    
    func UUIDs() -> [UUID] {
        return [uniqueIdentifier]
    }
    
    public enum SensorType {
        case temperature
        case humidity
        case unknown
    }
    
    
    func bind(with uniqueIdentifier: UUID) -> Bool {
        return self.uniqueIdentifier == uniqueIdentifier
    }
    
    func update(enable: Bool) {
        self.isEnabled = enable
//        switch (self.type, value) {
//        case (.temperature, let value as NSNumber):
//            self.title = "\(value.floatValue)℃"
//        case (.humidity, let value as NSNumber):
//            self.title = "\(value.floatValue)%"
//        default:
//            self.title = "unsupported"
//        }
    }

    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.uniqueIdentifier = UUID()
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
        super.init(title: actionSetInfo.name, action: nil, keyEquivalent: "")
        self.action = #selector(self.execute(sender:))
        self.target = self
    }
}
