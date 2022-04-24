//
//  CameraMenu.swift
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

class CameraMenuItem: NSMenuItem, MenuItemFromUUID {
    func UUIDs() -> [UUID] {
        [accessoryCharacteristicIdentifier]
    }
    
    func bind(with uniqueIdentifier: UUID) -> Bool {
        return accessoryCharacteristicIdentifier == uniqueIdentifier
    }
    
    let accessoryCharacteristicIdentifier: UUID
    var mac2ios: mac2iOS?
        
    @IBAction func open(sender: NSMenuItem) {
        self.mac2ios?.openCamera(uniqueIdentifier: accessoryCharacteristicIdentifier)
    }
    
    init?(accessoryInfo: AccessoryInfoProtocol, mac2ios: mac2iOS?) {
        guard accessoryInfo.hasCamera else { return nil }
        
        self.mac2ios = mac2ios
        self.accessoryCharacteristicIdentifier = accessoryInfo.uniqueIdentifier
        super.init(title: accessoryInfo.name ?? "camera", action: nil, keyEquivalent: "")
        
        self.image = NSImage(systemSymbolName: "camera", accessibilityDescription: nil)
        self.action = #selector(CameraMenuItem.open(sender:))
        self.target = self
    }

    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.accessoryCharacteristicIdentifier = UUID()
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
