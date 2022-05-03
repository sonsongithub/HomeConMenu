//
//  BaseManager.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/06.
//

import Foundation
import HomeKit
import os

private let scribe = OSLog(subsystem: "iOS", category: "BaseManager")
private let homekitLogger = OSLog(subsystem: "iOS", category: "HomeKit")

class BaseManager: NSObject, HMHomeManagerDelegate, HMAccessoryDelegate, mac2iOS, HMHomeDelegate {

    func getArray() -> [AccessoryInfoProtocol] {
        return infoArray
    }
    
    func updateColor(uniqueIdentifier: UUID, value: Double) {
        guard let characteristic = self.homeManager?.getCharacteristic(with: uniqueIdentifier) else { return }
        characteristic.writeValue(value) { error in
            if let error = error {
                os_log("[com.sonson.HomeConMenu.macOS] %@", log: homekitLogger, type: .error, error.localizedDescription)
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
                                os_log("[com.sonson.HomeConMenu.macOS] %@", log: homekitLogger, type: .error, error.localizedDescription)
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
                    os_log("[com.sonson.HomeConMenu.macOS] %@", log: homekitLogger, type: .error, error.localizedDescription)
                } else {
                    if let value = characteristic.value as? NSNumber {
                        if value.intValue == 0 {
                            let newValue = Int(1)
                            characteristic.writeValue(newValue) { error in
                                if let error = error {
                                    os_log("[com.sonson.HomeConMenu.macOS] %@", log: homekitLogger, type: .error, error.localizedDescription)
                                } else {
                                    let charaInfo = CharacteristicInfo(characteristic: characteristic)
                                    self.ios2mac?.didUpdate(chracteristicInfo: charaInfo)
                                }
                            }
                        } else if value.intValue == 1 {
                            let newValue = Int(0)
                            characteristic.writeValue(newValue) { error in
                                if let error = error {
                                    os_log("[com.sonson.HomeConMenu.macOS] %@", log: homekitLogger, type: .error, error.localizedDescription)
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

        guard let bundleURL = Bundle.main.builtInPlugInsURL?.appendingPathComponent(bundleFile) else {
            os_log("[com.sonson.HomeConMenu.macOS] Failed to create bundle URL.", log: scribe, type: .error)
            return
        }
        guard let bundle = Bundle(url: bundleURL) else {
            os_log("[com.sonson.HomeConMenu.macOS] Failed to load a bundle file.", log: scribe, type: .error)
            return
        }
        guard let pluginClass = bundle.principalClass as? iOS2Mac.Type else {
            os_log("[com.sonson.HomeConMenu.macOS] Failed to load the principalClass.", log: scribe, type: .error)
            return
        }
        ios2mac = pluginClass.init()
        ios2mac?.iosListener = self
        os_log("[com.sonson.HomeConMenu.macOS] iOS2Mac has been loaded.", log: scribe, type: .info)
    }
    
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        os_log("[com.sonson.HomeConMenu.macOS] accessoryDidUpdateServices", log: homekitLogger, type: .info)
    }
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        os_log("[com.sonson.HomeConMenu.macOS] accessory:service:didUpdateValueFor:characteristic:", log: scribe, type: .info)
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
        if status.contains(.restricted) {
            os_log("[com.sonson.HomeConMenu.macOS] HomeConMenu is not authorized to access HomeKit.", log: scribe, type: .info)
            _ = ios2mac?.openHomeKitAuthenticationError()
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        } else {
            os_log("[com.sonson.HomeConMenu.macOS] HomeConMenu is authorized to access HomeKit.", log: scribe, type: .info)
        }
        ios2mac?.didUpdate()
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
        os_log("[com.sonson.HomeConMenu.macOS] homeManagerDidUpdatePrimaryHome:", log: homekitLogger, type: .info)
    }
    
    func home(_ home: HMHome, didUnblockAccessory accessory: HMAccessory) {
        os_log("[com.sonson.HomeConMenu.macOS] home:didUnblockAccessory:", log: homekitLogger, type: .info)
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        os_log("[com.sonson.HomeConMenu.macOS] homeManagerDidUpdateHomes", log: homekitLogger, type: .info)
        
        guard let home = manager.primaryHome else {
            os_log("[com.sonson.HomeConMenu.macOS] Any homes have not been found.", log: homekitLogger, type: .info)
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
            ios2mac?.didUpdate()
            return
        }
        home.delegate = self
        
        for accessory in home.accessories {
            let info = accessory.convert2info()
            accessory.delegate = self
            self.infoArray.append(info)
        }
        ios2mac?.didUpdate()
        
        if !UserDefaults.standard.bool(forKey: "doesNotShowLaunchViewController") {
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        }
    }
    
    func openAbout() {
        let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
        userActivity.title = "default"
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
    }
}
