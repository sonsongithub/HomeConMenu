//
//  SensorMenu.swift
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

class SensorMenuItem: NSMenuItem, MenuItemFromUUID, ErrorMenuItem {
    var mac2ios: mac2iOS?
    let uniqueIdentifier: UUID
    let type: SensorType
    
    var reachable: Bool {
        didSet {
            if reachable {
                switch self.type {
                case .temperature:
                    self.image = NSImage(systemSymbolName: "thermometer", accessibilityDescription: nil)
                case .humidity:
                    self.image = NSImage(systemSymbolName: "humidity", accessibilityDescription: nil)
                default:
                    do{}
                }
            } else {
                self.image = NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
            }
        }
    }
    
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
    
    func update(value: Double) {
        reachable = true
        switch (self.type, value) {
        case (.temperature, let value):
            self.title = "\(value)℃"
        case (.humidity, let value):
            self.title = "\(value)%"
        default:
            self.title = "unsupported"
        }
    }

    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.uniqueIdentifier = UUID()
        self.type = .unknown
        self.reachable = true
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init?(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        
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
        
        self.reachable = true
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
        
        if let mac2ios = mac2ios {
            do {
                guard let value = try mac2ios.getCharacteristic(of: uniqueIdentifier) as? Double
                else { throw HomeConMenuError.characteristicTypeError }
                update(value: value)
            } catch {
                Logger.app.error("\(error.localizedDescription)")
            }
        }
    }
}
