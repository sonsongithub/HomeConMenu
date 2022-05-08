//
//  BaseManager.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/06.
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

import Foundation
import HomeKit
import os

class BaseManager: NSObject, HMHomeManagerDelegate, HMAccessoryDelegate, mac2iOS, HMHomeDelegate {

    var homeManager: HMHomeManager?
    var macOSController: iOS2Mac?
    
    var accessories: [AccessoryInfoProtocol] = []
    var serviceGroups: [ServiceGroupInfoProtocol] = []
    var rooms: [RoomInfoProtocol] = []
    var actionSets: [ActionSetInfoProtocol] = []
    
    override init() {
        super.init()
        loadPlugin()
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }
    
    func loadPlugin() {
        let bundleFile = "macOSBridge.bundle"

        guard let bundleURL = Bundle.main.builtInPlugInsURL?.appendingPathComponent(bundleFile) else {
            Logger.app.error("Failed to create bundle URL.")
            return
        }
        guard let bundle = Bundle(url: bundleURL) else {
            Logger.app.error("Failed to load a bundle file.")
            return
        }
        guard let pluginClass = bundle.principalClass as? iOS2Mac.Type else {
            Logger.app.error("Failed to load the principalClass.")
            return
        }
        macOSController = pluginClass.init()
        macOSController?.iosListener = self
        Logger.app.info("iOS2Mac has been loaded.")
    }
    
    func getTargetValues(of uniqueIdentifier: UUID) throws -> [Any] {
        guard let home = self.homeManager?.primaryHome else { throw HomeConMenuError.primaryHomeNotFound }
        guard let actionSet = home.actionSets.first(where: { $0.uniqueIdentifier == uniqueIdentifier })
        else { throw HomeConMenuError.actionSetNotFound }
        let writeActions = actionSet.actions.compactMap( { $0 as? HMCharacteristicWriteAction<NSCopying> })
        
        return writeActions.map({$0.targetValue as Any})
    }
    
    func reloadAllItems() {
        guard let home = self.homeManager?.primaryHome else {
            Logger.app.info("Primary home has not been found.")
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
            macOSController?.openNoHomeError()
            macOSController?.reloadAllMenuItems()
            return
        }
        home.delegate = self
        
#if DEBUG
        home.dump()
#endif

        accessories = home.accessories.map({$0.convert2info(delegate: self)})
        serviceGroups = home.serviceGroups.map({ServiceGroupInfo(serviceGroup: $0)})
        rooms = home.rooms.map({ RoomInfo(name: $0.name, uniqueIdentifier: $0.uniqueIdentifier) })
        
        actionSets = home.actionSets.filter({ $0.isHomeKitScene }).map({ ActionSetInfo(actionSet: $0)})
        
        if accessories.count == 0 {
            UserDefaults.standard.set(false, forKey: "doesNotShowLaunchViewController")
            UserDefaults.standard.synchronize()
        }
        
        if !UserDefaults.standard.bool(forKey: "doesNotShowLaunchViewController") {
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        }
        macOSController?.reloadAllMenuItems()
    }
    
}

extension BaseManager {
    
    func executeActionSet(uniqueIdentifier: UUID) {
        guard let home = homeManager?.primaryHome else { return }
        guard let actionSet = home.actionSets.first(where: { $0.uniqueIdentifier == uniqueIdentifier }) else { return }
        if !actionSet.isExecuting {
            home.executeActionSet(actionSet) { error in
                if let error = error {
                    Logger.homeKit.error("\(error.localizedDescription)")
                } else {
                    for writeAction in actionSet.actions.compactMap({ $0 as? HMCharacteristicWriteAction<NSCopying> }) {
                        self.macOSController?.updateItems(of: writeAction.uniqueIdentifier, value: writeAction.targetValue)
                    }
                }
            }
        } else {
            Logger.app.error("This action set has beeen already executing.")
        }
    }
    
    func reload(uniqueIdentifiers: [UUID]) {
        
        let characteristicsInfo = self.accessories
            .map({$0.services})
            .flatMap({$0})
            .map({$0.characteristics})
            .flatMap({$0})
        
        guard let home = self.homeManager?.primaryHome else { return }
        
        let chars: [HMCharacteristic] = home.accessories
            .map({ $0.services })
            .flatMap({ $0 })
            .map({ $0.characteristics })
            .flatMap({ $0 })
        
        for uniqueIdentifier in uniqueIdentifiers {
            for char in chars {
                guard let info = characteristicsInfo.first(where: { $0.uniqueIdentifier == uniqueIdentifier }) else { continue }
                if char.uniqueIdentifier == uniqueIdentifier {
                    char.readValue { error in
                        if let error = error {
                            Logger.homeKit.error("\(error.localizedDescription)")
                            self.macOSController?.updateItems(of: uniqueIdentifier, isReachable: false)
                        } else {
                            info.value = char.value
                            self.macOSController?.updateItems(of: uniqueIdentifier, value: char.value as Any)
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
        
    func setCharacteristic(of uniqueIdentifier: UUID, object: Any) {
        if let characteristic = homeManager?.getCharacteristic(with: uniqueIdentifier) {
            characteristic.writeValue(object) { error in
                if let error = error {
                    Logger.homeKit.error("\(error.localizedDescription)")
                    self.macOSController?.updateItems(of: uniqueIdentifier, isReachable: false)
                } else {
                    self.macOSController?.updateItems(of: uniqueIdentifier, value: object)
                }
            }
        }
    }
    
    func getCharacteristic(of uniqueIdentifier: UUID) throws -> Any {
        guard let characteristic = homeManager?.getCharacteristic(with: uniqueIdentifier)
        else { throw HomeConMenuError.characteristicNotFound }
        guard characteristic.value != nil else { throw HomeConMenuError.characteristicValueNil }
        return characteristic.value as Any
    }
    
    func openPreferences() {
        let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.PreferenceView")
        userActivity.title = "default"
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
    }
    
    func openAbout() {
        let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
        userActivity.title = "default"
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
    }
}
