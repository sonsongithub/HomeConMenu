//
//  OutletMenuItem.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/06.
//

import Cocoa
//
//class OutletMenuItem: NSMenuItem, MenuItemFromUUID {
//    func UUIDs() -> [UUID] {
//        return powerCharacteristicIdentifiers
//    }
//    
//    func bind(with uniqueIdentifier: UUID) -> Bool {
//        return powerCharacteristicIdentifiers.contains(where: { $0 == uniqueIdentifier })
//    }
//    
//    let powerCharacteristicIdentifiers: [UUID]
//    var mac2ios: mac2iOS?
//    
//    @IBAction func toggle(sender: NSMenuItem) {
//        if powerCharacteristicIdentifiers.count == 1 {
//            for uuid in powerCharacteristicIdentifiers {
//                self.mac2ios?.toggleValue(uniqueIdentifier: uuid)
//            }
//            self.state = (self.state == .on) ? .off : .on
//        } else {
//            guard let sample = powerCharacteristicIdentifiers.first else { return }
//            guard let state = self.mac2ios?.getPowerState(uniqueIdentifier: sample) else { return }
//            for uuid in powerCharacteristicIdentifiers {
//                self.mac2ios?.setPowerState(uniqueIdentifier: uuid, state: !state)
//            }
//        }
//    }
//    
//    func update(value: Int) {
//        guard let sample = powerCharacteristicIdentifiers.first else { return }
//        guard let state = self.mac2ios?.getPowerState(uniqueIdentifier: sample) else { return }
//        self.state = state ? .on : .off
//    }
//        
//    init?(serviceGroupInfo: ServiceGroupInfoProtocol, mac2ios: mac2iOS?) {
//
//        let characteristicInfos = serviceGroupInfo.services.map({ $0.characteristics }).flatMap({ $0 })
//           
//        let infos = characteristicInfos.filter({ $0.type == .powerState })
//        
//        guard infos.count > 0 else { return nil }
//        
//        guard let sample = infos.first else { return nil}
//        
//        
//        let uuids = infos.map({$0.uniqueIdentifier})
//        
//        self.mac2ios = mac2ios
//        self.powerCharacteristicIdentifiers = uuids
//        super.init(title: serviceGroupInfo.name, action: nil, keyEquivalent: "")
//
//        if let number = sample.value as? Int {
//            self.state = (number == 0) ? .off : .on
//        }
//        self.image = NSImage(systemSymbolName: "powerplug", accessibilityDescription: nil)
//        self.action = #selector(OutletMenuItem.toggle(sender:))
//        self.target = self
//    }
//        
//    init?(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
//        //mac2ios: mac2iOS?, title: Any?, uniqueIdentifier: UUID, state: Any?, type: ServiceType) {
//        guard let powerStateChara = serviceInfo.characteristics.first(where: { obj in
//            obj.type == .powerState
//        }) else { return nil }
//        
//        self.mac2ios = mac2ios
//        self.powerCharacteristicIdentifiers = [powerStateChara.uniqueIdentifier]
//        super.init(title: serviceInfo.name, action: nil, keyEquivalent: "")
//        
//        if let number = powerStateChara.value as? Int {
//            self.state = (number == 0) ? .off : .on
//        }
//        self.image = NSImage(systemSymbolName: "powerplug", accessibilityDescription: nil)
//        self.action = #selector(OutletMenuItem.toggle(sender:))
//        self.target = self
//    }
//    
//    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
//        fatalError()
//    }
//    
//    required init(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//}
