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
    
    func reloadSceneStatus() {
        guard let home = self.homeManager?.primaryHome else { return }
        
        let results: [(UUID, Bool)] = home.actionSets.filter({ $0.isHomeKitScene }).map { actionSet in
            let writeActions = actionSet.actions.compactMap({ $0 as? HMCharacteristicWriteAction<NSCopying> })
            
            let status = writeActions.reduce(true) { partialResult, writeAction in
                switch (writeAction.targetValue, writeAction.characteristic.value) {
                case (let targetValue as Int, let currentValue as Int):
                    return partialResult && (targetValue == currentValue)
                default:
                    return false
                }
            }
            return (actionSet.uniqueIdentifier, status)
        }
        
        let UUIDs = results.map({$0.0})
        let status = results.map({$0.1})
        
        self.macOSController?.updateScene(UUIDs: UUIDs, status: status)
    }
    
    func reloadAllItems() {
        guard let home = self.homeManager?.primaryHome else {
            Logger.app.info("Primary home has not been found.")
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
            macOSController?.openNoHomeError()
            macOSController?.didUpdate()
            return
        }
        home.delegate = self
        
#if DEBUG
        home.dump()
#else
#endif

        accessories = home.accessories.map({$0.convert2info(delegate: self)})
        serviceGroups = home.serviceGroups.map({ServiceGroupInfo(serviceGroup: $0)})
        rooms = home.rooms.map({ RoomInfo(name: $0.name, uniqueIdentifier: $0.uniqueIdentifier) })
        
        actionSets = home.actionSets.filter({ $0.isHomeKitScene }).map({ ActionSetInfo(actionSet: $0)})
        
        if !UserDefaults.standard.bool(forKey: "doesNotShowLaunchViewController") {
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        }
        macOSController?.didUpdate()
        reloadSceneStatus()
    }
    
}

extension BaseManager {
    
    func updateColor(uniqueIdentifier: UUID, value: Double) {
        guard let characteristic = self.homeManager?.getCharacteristic(with: uniqueIdentifier) else { return }
        characteristic.writeValue(value) { error in
            if let error = error {
                Logger.homeKit.error("\(error.localizedDescription)")
            }
        }
    }
    
    func executeActionSet(uniqueIdentifier: UUID) {
        guard let home = homeManager?.primaryHome else { return }
        guard let actionSet = home.actionSets.first(where: { $0.uniqueIdentifier == uniqueIdentifier }) else { return }
        if !actionSet.isExecuting {
            home.executeActionSet(actionSet) { error in
                if let error = error {
                    Logger.homeKit.error("\(error.localizedDescription)")
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
                            info.enable = false
                            self.macOSController?.didUpdate(chracteristicInfo: info)
                        } else {
                            info.value = char.value
                            self.macOSController?.didUpdate(chracteristicInfo: info)
                            info.enable = true
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
    
    func getPowerState(uniqueIdentifier: UUID) -> Bool {
        guard let characteristic = homeManager?.getCharacteristic(with: uniqueIdentifier) else { return false }
        guard let state = characteristic.value as? Bool else { return false }
        return state
    }
    
    func setPowerState(uniqueIdentifier: UUID, state: Bool) {
        if let characteristic = homeManager?.getCharacteristic(with: uniqueIdentifier) {
            characteristic.writeValue(state) { error in
                if let error = error {
                    Logger.homeKit.error("\(error.localizedDescription)")
                }
            }
        }
    }
    
    func toggleValue(uniqueIdentifier: UUID) {
        if let characteristic = homeManager?.getCharacteristic(with: uniqueIdentifier) {
            characteristic.readValue { error in
                if let error = error {
                    Logger.homeKit.error("\(error.localizedDescription)")
                } else {
                    if let value = characteristic.value as? NSNumber {
                        if value.intValue == 0 || value.intValue == 1 {
                            let newValue = 1 - value.intValue
                            characteristic.writeValue(newValue) { error in
                                if let error = error {
                                    Logger.homeKit.error("\(error.localizedDescription)")
                                } else {
                                    let charaInfo = CharacteristicInfo(characteristic: characteristic)
                                    self.macOSController?.didUpdate(chracteristicInfo: charaInfo)
                                    self.reloadSceneStatus()
                                }
                            }
                        }
                    }
                }
            }
        }
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
