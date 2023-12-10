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
    
    func close(windows: [Any]) {
        let uiWindows = windows.compactMap({ $0 as? UIWindow })
        UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .filter({ $0.windows.count > 0 })
            .forEach { windowScene in
                windowScene.windows.forEach { window in
                    if uiWindows.contains(where: { $0 == window }) {
                    UIApplication.shared.requestSceneSessionDestruction(windowScene.session, options: nil)
                    window.rootViewController = nil
                    Logger.app.info("close UIWindow(\(window)")
                }
            }
        }
    }
    
    var homeManager: HMHomeManager?
    var macOSController: iOS2Mac?
    
    var accessories: [AccessoryInfoProtocol] = []
    var serviceGroups: [ServiceGroupInfoProtocol] = []
    var rooms: [RoomInfoProtocol] = []
    var actionSets: [ActionSetInfoProtocol] = []
    var homes: [HomeInfoProtocol] = []
    
    var homeUniqueIdentifier: UUID? {
        didSet {
            UserDefaults.standard.set(homeUniqueIdentifier?.uuidString, forKey: "LastHomeUUID")
        }
    }
    
    override init() {
        super.init()
        if let lastHomeUUIDString = UserDefaults.standard.string(forKey: "LastHomeUUID") {
            if let uuid = UUID(uuidString: lastHomeUUIDString) {
                self.homeUniqueIdentifier = uuid
            }
        }
        loadPlugin()
        homeManager = HMHomeManager()
        homeManager?.delegate = self
        NotificationCenter.default.addObserver(self, selector: #selector(self.didPathUpdate), name: MonitoringNetworkState.didPathUpdateNotification, object: nil)
    }
    
    /// This method is called when network status is changed.
    /// - Parameter notification: Notification
    @objc func didPathUpdate(notification: Notification) {
        Logger.app.info("MonitoringNetworkState.didPathUpdateNotification")
        rebootHomeManager()
    }
    
    /// Load plugin
    /// Load bundle file and attached to a property.
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
    
    /// Get value from service whose characteristic is to write value.
    /// - Parameter uniqueIdentifier: UUID of the service.
    /// - Returns: Array of values.
    func getTargetValues(of uniqueIdentifier: UUID) throws -> [Any] {
        guard let home = self.homeManager?.usedHome(with: self.homeUniqueIdentifier) else { throw HomeConMenuError.primaryHomeNotFound }
        guard let actionSet = home.actionSets.first(where: { $0.uniqueIdentifier == uniqueIdentifier })
        else { throw HomeConMenuError.actionSetNotFound }
        let writeActions = actionSet.actions.compactMap( { $0 as? HMCharacteristicWriteAction<NSCopying> })
        
        return writeActions.map({$0.targetValue as Any})
    }
    
    /// Fetch informations of homes, rooms, accessories and services from HomeKit and send a request to macOS module.
    /// This method is called when the home manager has been updated.
    func fetchFromHomeKitAndReloadMenuExtra() {
        
        guard let home = self.homeManager?.usedHome(with: self.homeUniqueIdentifier) else {
            Logger.app.error("Any home have not been found.")
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
            macOSController?.openNoHomeError()
            macOSController?.reloadMenuExtra()
            return
        }
        home.delegate = self
        
        // update uniqueidentifier of home.
        if let tmpHome = homeManager?.usedHome(with: self.homeUniqueIdentifier) {
            self.homeUniqueIdentifier = tmpHome.uniqueIdentifier
        } else {
            if let t = homeManager?.homes.first {
                self.homeUniqueIdentifier = t.uniqueIdentifier
            }
        }
#if DEBUG
//        home.dump()
#endif
        homes = homeManager?.homes.map({ HomeInfo(name: $0.name, uniqueIdentifier: $0.uniqueIdentifier) }) ?? []
        accessories = home.accessories.map({$0.convert2info(delegate: self)})
        serviceGroups = home.serviceGroups.map({ServiceGroupInfo(serviceGroup: $0)})
        rooms = home.rooms.map({ RoomInfo(name: $0.name, uniqueIdentifier: $0.uniqueIdentifier) })
        actionSets = home.actionSets.filter({ $0.isHomeKitScene }).map({ ActionSetInfo(actionSet: $0)})
        
        if accessories.count == 0 {
            UserDefaults.standard.set(true, forKey: "showLaunchViewController")
            UserDefaults.standard.synchronize()
        }
        if UserDefaults.standard.bool(forKey: "showLaunchViewController") {
            // open launchview
            macOSController?.showLaunchView()
        }
        macOSController?.reloadMenuExtra()
    }
}

extension BaseManager {
    
    /// Execute action set whose unique identifier is specified by `uniqueIdentifier`.
    /// - Parameter uniqueIdentifier: UUID of the action set.
    func executeActionSet(uniqueIdentifier: UUID) {
        guard let home = homeManager?.usedHome(with: self.homeUniqueIdentifier) else { return }
        guard let actionSet = home.actionSets.first(where: { $0.uniqueIdentifier == uniqueIdentifier }) else { return }
        guard !actionSet.isExecuting else { Logger.app.error("This action set has beeen already executing.");return }
        
        Task.detached {
            do {
                try await home.executeActionSet(actionSet)
                DispatchQueue.main.async {
                    for writeAction in actionSet.actions.compactMap({ $0 as? HMCharacteristicWriteAction<NSCopying> }) {
                        self.macOSController?.updateItems(of: writeAction.uniqueIdentifier, value: writeAction.targetValue)
                    }
                }
            } catch {
                Logger.homeKit.error("Can not execute actionset - \(error.localizedDescription)")
            }
        }
    }
    
    /// Request to read value of characteristic whose unique identifier is specified by `uniqueIdentifier`.
    /// Reading value is not execute synchronously.
    /// - Parameter uniqueIdentifier: UUID of the characteristic.
    func readCharacteristic(of uniqueIdentifier: UUID) {
        guard let characteristic = homeManager?.getCharacteristic(from: self.homeUniqueIdentifier, with: uniqueIdentifier) else { return }
        Task {
           do {
               try await characteristic.readValue()
               DispatchQueue.main.async {
                   self.macOSController?.updateItems(of: uniqueIdentifier, value: characteristic.value as Any)
               }
           } catch {
               Logger.homeKit.error("Can not read value - \(error.localizedDescription)")
               DispatchQueue.main.async {
                   self.macOSController?.updateItems(of: uniqueIdentifier, isReachable: false)
               }
           }
        }
    }
    
    /// Request to write value of characteristic whose unique identifier is specified by `uniqueIdentifier`.
    /// - Parameters: uniqueIdentifier: UUID of the characteristic.
    /// - Parameters: object: Value to write.
    func setCharacteristic(of uniqueIdentifier: UUID, object: Any) {
        guard let characteristic = homeManager?.getCharacteristic(from: self.homeUniqueIdentifier, with: uniqueIdentifier) else { return }
        Task.detached {
            do {
                try await characteristic.writeValue(object)
                DispatchQueue.main.async {
                    self.macOSController?.updateItems(of: uniqueIdentifier, value: object)
                }
            } catch {
                Logger.homeKit.error("Can not write value - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.macOSController?.updateItems(of: uniqueIdentifier, isReachable: false)
                }
            }
        }
    }
    
    /// Return value of characteristic whose unique identifier is specified by `uniqueIdentifier`.
    /// - Parameter uniqueIdentifier: UUID of the characteristic.
    /// - Returns: Value of the characteristic.
    func getCharacteristic(of uniqueIdentifier: UUID) throws -> Any {
        guard let characteristic = homeManager?.getCharacteristic(from: self.homeUniqueIdentifier, with: uniqueIdentifier)
        else { throw HomeConMenuError.characteristicNotFound }
        guard characteristic.value != nil else { throw HomeConMenuError.characteristicValueNil }
        return characteristic.value as Any
    }
    
    func openCamera(uniqueIdentifier: UUID) {
        guard let accessory = self.homeManager?.getAccessory(from: self.homeUniqueIdentifier, with: uniqueIdentifier) else { return }
        guard let cameraProfile = accessory.cameraProfiles?.first else { return }
        guard cameraProfile.streamControl?.delegate == nil else { return }
        
        let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.openCamera")
        userActivity.title = "default"
        userActivity.addUserInfoEntries(from: ["uniqueIdentifier": uniqueIdentifier])
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        
        self.macOSController?.bringToFront()
    }
    
    func rebootHomeManager() {
        Logger.app.info("rebootHomeManager")
        homeManager?.delegate = nil
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }
    
    func openAcknowledgement() {
        let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.Acknowledgement")
        userActivity.title = "default"
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        self.macOSController?.bringToFront()
    }
}
