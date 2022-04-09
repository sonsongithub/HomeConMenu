//
//  SensorMenu.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/20.
//

import Cocoa

class SensorMenuItem: NSMenuItem, MenuItemFromUUID {
    
    func UUIDs() -> [UUID] {
        return [uniqueIdentifier]
    }
    
    public enum SensorType {
        case temperature
        case humidity
        case unknown
    }
    
    let uniqueIdentifier: UUID
    let type: SensorType
    
    func bind(with uniqueIdentifier: UUID) -> Bool {
        return self.uniqueIdentifier == uniqueIdentifier
    }
    
    func update(value: Any?) {
        switch (self.type, value) {
        case (.temperature, let value as NSNumber):
            self.title = "\(value.floatValue)℃"
        case (.humidity, let value as NSNumber):
            self.title = "\(value.floatValue)%"
        default:
            self.title = "unsupported"
        }
    }

    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.uniqueIdentifier = UUID()
        self.type = .unknown
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol) {
        
        func decideType(serviceInfo: ServiceInfoProtocol) -> (CharacteristicInfoProtocol, SensorType)? {
            if serviceInfo.type == .humiditySensor {
                guard let humidityChara = serviceInfo.characteristics.first(where: { obj in
                    obj.type == .currentRelativeHumidity
                }) else { return nil }
                return (humidityChara, .humidity)
            } else if serviceInfo.type == .temperatureSensor {
                guard let temperatureChara = serviceInfo.characteristics.first(where: { obj in
                    obj.type == .currentTemperature
                }) else { return nil }
                return (temperatureChara, .temperature)
            }
            return nil
        }
        
        guard let (characteristicInfo, type) = decideType(serviceInfo: serviceInfo) else { return nil }
        
        self.uniqueIdentifier = characteristicInfo.uniqueIdentifier
        self.type = type
        super.init(title: "", action: nil, keyEquivalent: "")
        
        switch self.type {
        case .temperature:
            self.image = NSImage(systemSymbolName: "thermometer", accessibilityDescription: nil)
        case .humidity:
            self.image = NSImage(systemSymbolName: "humidity", accessibilityDescription: nil)
        default:
            do{}
        }
        update(value: characteristicInfo.value)
    }
}
