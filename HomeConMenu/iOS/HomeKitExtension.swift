//
//  HomeKitExtension.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/21.
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

import HomeKit
import os

extension HMCharacteristic {
    /// Get the detail of the characteristic.
    /// For example, "The current light level."
    public var detail: String {
        let info = CharacteristicInfo(characteristic: self)
        return info.type.detail
    }
    
    /// Get the characteristic type string of the characteristic as Accessory Characteristic Types.
    /// For example, HMCharacteristicTypeCurrentTemperature.
    public var typeAsString: String {
        let info = CharacteristicInfo(characteristic: self)
        return info.type.description
    }
    
    /// Indicates whether the current HomeConMenu supports this characteristic.
    public var isSupported: Bool {
        return CharacteristicType(key: self.characteristicType).isSupported
    }
}

extension HMService {
    /// Get the service detail of the service.
    /// For example, "A temperature sensor service."
    public var detail: String {
        let tmp = ServiceType(key: self.serviceType)
        return tmp.detail
    }
    
    /// Get the service type string of the service as Accessory Service Types.
    /// For example, HMServiceTypeLightbulb.
    public var typeAsString: String {
        let tmp = ServiceType(key: self.serviceType)
        return tmp.description
    }
    
    /// Indicates whether the current HomeConMenu supports this service.
    public var isSupported: Bool {
        return ServiceType(key: self.serviceType).isSupported
    }
}

extension HMHomeManager {
    /// Get the home with the unique identifier.
    /// - Parameters:
    ///      - uniqueIdentifier: Unique identifier of the home.
    /// - Returns: The home with the unique identifier.
    func usedHome(with uniqueIdentifier: UUID?) -> HMHome? {
        for home in self.homes {
            if home.uniqueIdentifier == uniqueIdentifier {
                return home
            }
        }
        return self.homes.first
    }
    
    /// Get the characteristic  whose unique is specified as `uniqueIdentifier` in the home whose unique is specified as `homeUniqueIdentifier`.
    /// - Parameters:
    ///     - homeUniqueIdentifier: Unique identifier of the home.
    ///     - uniqueIdentifier: Unique identifier of the characteristic.
    /// - Returns: The characteristic with the unique identifier.
    func getCharacteristic(from homeUniqueIdentifier: UUID?, with uniqueIdentifier: UUID) -> HMCharacteristic? {
        guard let home = self.usedHome(with: homeUniqueIdentifier) else { return nil }
        for accessory in home.accessories {
            for service in accessory.services {
                for characteristic in service.characteristics {
                    if characteristic.uniqueIdentifier == uniqueIdentifier {
                        return characteristic
                    }
                }
            }
        }
        return nil
    }
    
    /// Get the characteristic whose unique is specified as `uniqueIdentifier` in the primary home.
    /// - Parameters:
    ///    - uniqueIdentifier: Unique identifier of the characteristic.
    /// - Returns: The characteristic with the unique identifier.
    @available(*, deprecated, message: "Use getCharacteristic(from:with:) instead.")
    func getCharacteristic(with uniqueIdentifier: UUID) -> HMCharacteristic? {
        guard let primaryHome = self.primaryHome else { return nil }
        for accessory in primaryHome.accessories {
            for service in accessory.services {
                for characteristic in service.characteristics {
                    if characteristic.uniqueIdentifier == uniqueIdentifier {
                        return characteristic
                    }
                }
            }
        }
        return nil
    }
    
    /// Get the service whose unique identifier is specified as `uniqueIdentifier` in the home whose unique is specified as `homeUniqueIdentifier`.
    /// - Parameters:
    ///     - homeUniqueIdentifier: Unique identifier of the home.
    ///     - uniqueIdentifier: Unique identifier of the service.
    /// - Returns: The service with the unique identifier.
    func getService(from homeUniqueIdentifier: UUID?, with uniqueIdentifier: UUID) -> HMService? {
        guard let home = self.usedHome(with: homeUniqueIdentifier) else { return nil }
        for accessory in home.accessories {
            for service in accessory.services {
                if service.uniqueIdentifier == uniqueIdentifier {
                    return service
                }
            }
        }
        return nil
    }
    
    /// Get the service whose unique identifier is specified as `uniqueIdentifier` in the primary home.
    /// - Parameters:
    ///   - uniqueIdentifier: Unique identifier of the service.
    /// - Returns: The service with the unique identifier.
    @available(*, deprecated, message: "Use getService(from:with:) instead.")
    func getService(with uniqueIdentifier: UUID) -> HMService? {
        guard let primaryHome = self.primaryHome else { return nil }
        for accessory in primaryHome.accessories {
            for service in accessory.services {
                if service.uniqueIdentifier == uniqueIdentifier {
                    return service
                }
            }
        }
        return nil
    }
    
    /// Get the accessory whose unique identifier is specified as `uniqueIdentifier` in the home whose unique is specified as `homeUniqueIdentifier`.
    /// - Parameters:
    ///    - homeUniqueIdentifier: Unique identifier of the home.
    ///    - uniqueIdentifier: Unique identifier of the accessory.
    /// - Returns: The accessory with the unique identifier.
    func getAccessory(from homeUniqueIdentifier: UUID?, with uniqueIdentifier: UUID) -> HMAccessory? {
        guard let home = self.usedHome(with: homeUniqueIdentifier) else { return nil }
        for accessory in home.accessories {
            if accessory.uniqueIdentifier == uniqueIdentifier {
                return accessory
            }
        }
        return nil
    }
    
    /// Get the accessory whose unique identifier is specified as `uniqueIdentifier` in the primary home.
    /// - Parameters:
    ///     - uniqueIdentifier: Unique identifier of the accessory.
    /// - Returns: The accessory with the unique identifier.
    @available(*, deprecated, message: "Use getAccessory(from:with:) instead.")
    func getAccessory(with uniqueIdentifier: UUID) -> HMAccessory? {
        guard let primaryHome = self.primaryHome else { return nil }
        for accessory in primaryHome.accessories {
            if accessory.uniqueIdentifier == uniqueIdentifier {
                return accessory
            }
        }
        return nil
    }
}

extension HMHome {
    func dump() {
        for accessory in self.accessories {
            print("Accessory: \(accessory.name)")
            for service in accessory.services {
                print("    Service: \(service.name) \(service.uniqueIdentifier.uuidString)")
                for chara in service.characteristics {
                    print("        Characteristics: \(chara.detail)")
                    switch chara.value {
                    case let value as String:
                        print("        Value: \(value)")
                    case let value as NSNumber:
                        print("        Value: \(value)")
                    default:
                        print("        Value: Unexpected type")
                    }
                }
            }
        }
        
        for serviceGroup in self.serviceGroups {
            print("Service group: \(serviceGroup.name)")
            for service in serviceGroup.services {
                print("    Service: \(service.name)")
                for chara in service.characteristics {
                    print("        Characteristics: \(chara.detail)")
                    switch chara.value {
                    case let value as String:
                        print("        Value: \(value)")
                    case let value as NSNumber:
                        print("        Value: \(value)")
                    default:
                        print("        Value: Unexpected type")
                    }
                }
            }
        }
        
        for actionSet in  self.actionSets {
            print("Scene: \(actionSet.name) \(actionSet.uniqueIdentifier)")
            if actionSet.isHomeKitScene {
                print("    HomeKit Scene")
                print("    Actions")
            } else {
                print("    ShortCut Scene(not supported)")
            }
            for action in actionSet.actions {
                if let action = action as? HMCharacteristicWriteAction<NSCopying> {
                    print("        \(action.characteristic.detail)")
                    print("        Target value=\(action.targetValue)")
                    print("        Current value=\(action.characteristic.value as Any)")
                }
            }
        }
    }
}

extension HMActionSet {
    /// Whether the action set is a HomeKit scene or not.
    /// HomeConMenu find the HomeKit scene instances from ActionSet array that is returned from HomeKit API includes sets produced by Shortcuts.app.
    var isHomeKitScene: Bool {
        return actions.reduce(actions.count > 0) { partialResult, action in
            return partialResult && (action is HMCharacteristicWriteAction<NSCopying>)
        }
    }
}

extension HMAccessory {
    /// Get the accessory information as `AccessoryInfo` array.
    /// - Parameters:
    ///     - delegate: The delegate of the accessory, HMAccessoryDelegate.
    /// - Returns: The accessory information as `AccessoryInfo` array.
    func convert2info(delegate: HMAccessoryDelegate) -> AccessoryInfo {
        
        self.delegate = delegate
    
        let info = AccessoryInfo(accessory: self)
        
        if let room = self.room {
            info.room = RoomInfo(name: room.name, uniqueIdentifier: room.uniqueIdentifier)
        }
        
        if let cameraProfiles = self.cameraProfiles {
            info.hasCamera = (cameraProfiles.count > 0)
        }
        
        for service in self.services {
            let serviceInfo = ServiceInfo(service: service)
            for chara in service.characteristics {
                let charaInfo = CharacteristicInfo(characteristic: chara)
                charaInfo.type = CharacteristicType(key: chara.characteristicType)
                charaInfo.uniqueIdentifier = chara.uniqueIdentifier
                
                let typesNotificationUnsupporting: Set<CharacteristicType> = Set([.unknown, .hardwareVersion, .name, .identify])
                
                Task.detached {
                    do {
                        if !typesNotificationUnsupporting.contains(charaInfo.type) {
                            try await chara.enableNotification(true)
                        }
                    } catch {
                        Logger.homeKit.error("Can not enable notification - \(error.localizedDescription)")
                    }
                }
                
                Task.detached {
                    do {
                        try await chara.readValue()
                        DispatchQueue.main.async {
                            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                                delegate.baseManager?.macOSController?.updateMenuItemsRelated(to: chara.uniqueIdentifier, using: chara.value as Any)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            Logger.homeKit.error("Can not read value - \(error.localizedDescription)")
                            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                                delegate.baseManager?.macOSController?.setReachablityOfMenuItemRelated(to: chara.uniqueIdentifier, using: false)
                            }
                        }
                    }
                }
            }
            info.services.append(serviceInfo)
        }
        return info
    }
}
