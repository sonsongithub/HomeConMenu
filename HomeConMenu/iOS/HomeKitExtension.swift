//
//  HomeKitExtension.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/21.
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
            }
            info.services.append(serviceInfo)
            print("-------------------------------------")
        }
        return info
    }
}
