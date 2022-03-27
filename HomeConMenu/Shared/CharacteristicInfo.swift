//
//  Characteristics.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/08.
//

import Foundation

#if !os(macOS)
import HomeKit
#endif

@objc(CharacteristicInfoProtocol)
public protocol CharacteristicInfoProtocol: NSObjectProtocol {
    init()
    var uniqueIdentifier: UUID { get set }
    var value: Any? { get set }
    var type: CharacteristicType { get set }
    var characteristic: Any? { get set }
    var enable: Bool { get set }
}

public class CharacteristicInfo: NSObject, CharacteristicInfoProtocol {
    public var uniqueIdentifier: UUID = UUID()
    public var value: Any?
    public var type: CharacteristicType = .unknown
    public var characteristic: Any?
    public var enable = true
    
    required public override init() {
    }
#if !os(macOS)
    init(characteristic: HMCharacteristic) {
        super.init()
        uniqueIdentifier = characteristic.uniqueIdentifier
        value = characteristic.value
        type = CharacteristicType(key: characteristic.characteristicType)
    }
#endif
}

