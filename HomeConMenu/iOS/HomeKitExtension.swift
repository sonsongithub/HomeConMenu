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
    public var descriptionType: String {
        let info = CharacteristicInfo(characteristic: self)
        return info.type.description
    }
}

extension HMHomeManager {
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
                    print("        Characteristics: \(chara.descriptionType)")
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
                    print("        Characteristics: \(chara.descriptionType)")
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
                    print("        \(action.characteristic.descriptionType)")
                    print("        Target value=\(action.targetValue)")
                    print("        Current value=\(action.characteristic.value as Any)")
                }
            }
        }
    }
}

extension HMActionSet {
    var isHomeKitScene: Bool {
        return actions.reduce(actions.count > 0) { partialResult, action in
            return partialResult && (action is HMCharacteristicWriteAction<NSCopying>)
        }
    }
}

extension HMAccessory {
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
                        Logger.homeKit.error("Can not enable notification")
                        Logger.homeKit.error("\(error.localizedDescription)")
                    }
                }
                
                Task.detached {
                    do {
                        try await chara.readValue()
                        DispatchQueue.main.async {
                            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                                delegate.baseManager?.macOSController?.updateItems(of: chara.uniqueIdentifier, value: chara.value as Any)
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            Logger.homeKit.error("Can not read value")
                            Logger.homeKit.error("\(error.localizedDescription)")
                            if let delegate = UIApplication.shared.delegate as? AppDelegate {
                                delegate.baseManager?.macOSController?.updateItems(of: chara.uniqueIdentifier, isReachable: false)
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
