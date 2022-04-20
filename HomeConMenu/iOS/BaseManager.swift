//
//  BaseManager.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/06.
//

import Foundation
import HomeKit

class BaseManager: NSObject, HMHomeManagerDelegate, HMAccessoryDelegate, mac2iOS, HMHomeDelegate {

    func getArray() -> [AccessoryInfoProtocol] {
        return infoArray
    }
    
    func updateColor(uniqueIdentifier: UUID, value: Double) {
        guard let characteristic = self.homeManager?.getCharacteristic(with: uniqueIdentifier) else { return }
        characteristic.writeValue(value) { error in
            if let error = error {
                print(error)
            }
        }
    }
    
    func reload(uniqueIdentifiers: [UUID]) {
        
        let characteristics = self.infoArray
            .map({$0.services})
            .flatMap({$0})
            .map({$0.characteristics})
            .flatMap({$0})
        
        for uniqueIdentifier in uniqueIdentifiers {
            for characteristicInfo in characteristics {
                if characteristicInfo.uniqueIdentifier == uniqueIdentifier {
                    if let characteristic = characteristicInfo.characteristic as? HMCharacteristic {
                        characteristic.readValue { error in
                            if let error = error {
                                print(error)
                                characteristicInfo.enable = false
                                self.ios2mac?.didUpdate(chracteristicInfo: characteristicInfo)
                            } else {
                                characteristicInfo.value = characteristic.value
                                self.ios2mac?.didUpdate(chracteristicInfo: characteristicInfo)
                                characteristicInfo.enable = true
                            }
                        }
                    }
                }
            }
        }
    }
    
    func openCamera(uniqueIdentifier: UUID) {
        guard let accesory = self.homeManager?.getAccessory(with: uniqueIdentifier) else { return }
        guard let cameraProfile = accesory.cameraProfiles?.first else { return }
        guard cameraProfile.streamControl?.delegate == nil else { return }      // check wheter already camera view has been opened.
        
        let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.openCamera")
        userActivity.title = "default"
        userActivity.addUserInfoEntries(from: ["uniqueIdentifier": uniqueIdentifier])
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
    }
    
    var homeManager: HMHomeManager?
    var ios2mac: iOS2Mac?
    var infoArray: [AccessoryInfo] = []
    
    func toggleValue(uniqueIdentifier: UUID) {
        if let characteristic = homeManager?.getCharacteristic(with: uniqueIdentifier) {
            characteristic.readValue { error in
                if let error = error {
                    print(error)
                } else {
                    if let value = characteristic.value as? NSNumber {
                        if value.intValue == 0 {
                            let newValue = Int(1)
                            characteristic.writeValue(newValue) { error in
                                if let error = error {
                                    print(error)
                                } else {
                                    let charaInfo = CharacteristicInfo(characteristic: characteristic)
                                    self.ios2mac?.didUpdate(chracteristicInfo: charaInfo)
                                }
                            }
                        } else if value.intValue == 1 {
                            let newValue = Int(0)
                            characteristic.writeValue(newValue) { error in
                                if let error = error {
                                    print(error)
                                } else {
                                    let charaInfo = CharacteristicInfo(characteristic: characteristic)
                                    self.ios2mac?.didUpdate(chracteristicInfo: charaInfo)
                                }
                            }
                        }
                    }
                }
            }
        }
    }
    
    override init() {
        super.init()
        loadPlugin()
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }
    
    func loadPlugin() {
        let bundleFile = "macOSBridge.bundle"
        
    
        guard let bundleURL = Bundle.main.builtInPlugInsURL?.appendingPathComponent(bundleFile),
              let bundle = Bundle(url: bundleURL),
              let pluginClass = bundle.principalClass as? iOS2Mac.Type else { return }

        ios2mac = pluginClass.init()
        ios2mac?.iosListener = self
    }
    
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        print("accessoryDidUpdateServices")
    }
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        print("didUpdateValueFor")
        guard let obj = self.infoArray.first(where: { info in
            return info.uniqueIdentifier == accessory.uniqueIdentifier
        }) else { return }
        for service in obj.services {
            for chara in service.characteristics {
                if chara.uniqueIdentifier == characteristic.uniqueIdentifier {
                    chara.value = characteristic.value
                    ios2mac?.didUpdate(chracteristicInfo: chara)
                }
            }
        }
    }
    
    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
        print("didUpdate")
    }
    
    func home(_ home: HMHome, didAdd accessory: HMAccessory) {
        let info = accessory.convert2info()
        accessory.delegate = self
        self.infoArray.append(info)
        ios2mac?.didUpdate()
    }
    
    func home(_ home: HMHome, didRemove accessory: HMAccessory) {
        infoArray.removeAll { accessoryInfo in
            accessoryInfo.uniqueIdentifier == accessory.uniqueIdentifier
        }
        ios2mac?.didUpdate()
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        print("homeManagerDidUpdatePrimaryHome")
    }
    
    func home(_ home: HMHome, didUnblockAccessory accessory: HMAccessory) {
        print("didUnblockAccessory")
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        guard let home = manager.primaryHome else { return }
        home.delegate = self
        
        for accessory in home.accessories {
            let info = accessory.convert2info()
            accessory.delegate = self
            self.infoArray.append(info)
        }
        ios2mac?.didUpdate()
        
        if home.accessories.count == 0 {
            UserDefaults.standard.set(false, forKey: "DoesNotNeedLaunchViewController")
            UserDefaults.standard.synchronize()
        }
        let doesNotNeedLaunchViewController = UserDefaults.standard.bool(forKey: "DoesNotNeedLaunchViewController")
        if !doesNotNeedLaunchViewController {
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        }
    }
}
