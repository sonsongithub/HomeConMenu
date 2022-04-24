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

extension HMAccessory {
    func convert2info(delegate: HMAccessoryDelegate) -> AccessoryInfo {
        
        self.delegate = delegate
    
        let info = AccessoryInfo()
        
        if let room = self.room {
            info.room = RoomInfo(name: room.name, uniqueIdentifier: room.uniqueIdentifier)
        }
    
        info.name = self.name
        info.uniqueIdentifier = self.uniqueIdentifier
        
        if let cameraProfiles = self.cameraProfiles {
            info.hasCamera = (cameraProfiles.count > 0)
        }
        for service in self.services {
            let serviceInfo = ServiceInfo()
            serviceInfo.type = ServiceType(key: service.serviceType)
            print(service.name)
            
            print(ServiceType(key: service.serviceType))
            for chara in service.characteristics {
                
                let charaInfo = CharacteristicInfo()
                charaInfo.type = CharacteristicType(key: chara.characteristicType)
                serviceInfo.characteristics.append(charaInfo)
                charaInfo.value = chara.value
                charaInfo.uniqueIdentifier = chara.uniqueIdentifier
                charaInfo.characteristic = chara
                chara.enableNotification(true) { error in
//                    if let error = error {
//                        print(error)
//                    }
                }
                
                chara.readValue { error in
                    if let error = error {
                        print("\(service.name): Read Value error - \(error)")
                    } else {
                        if let delegate = UIApplication.shared.delegate as? AppDelegate {
                            print("\(service.name): \(chara.value)")
                            delegate.baseManager?.ios2mac?.didUpdate(chracteristicInfo: charaInfo)
                        }
                    }
                }
            }
            info.services.append(serviceInfo)
            print("-------------------------------------")
        }
        return info
    }
}
