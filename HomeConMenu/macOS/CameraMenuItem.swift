//
//  CameraMenu.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/20.
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
        super.init(title: "Open camera", action: nil, keyEquivalent: "")
        
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
