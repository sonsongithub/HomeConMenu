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
    
    /// HomeKit
    var homeManager: HMHomeManager?
    var macOSController: iOS2Mac?
    var homeUniqueIdentifier: UUID? {
        didSet {
            UserDefaults.standard.set(homeUniqueIdentifier?.uuidString, forKey: "LastHomeUUID")
        }
    }
    
    /// Information to bridge iOS and macOS
    /// mac2iOS
    var accessories: [AccessoryInfoProtocol] = []
    var serviceGroups: [ServiceGroupInfoProtocol] = []
    var rooms: [RoomInfoProtocol] = []
    var actionSets: [ActionSetInfoProtocol] = []
    var homes: [HomeInfoProtocol] = []
    
    /// init
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
        DispatchQueue.main.sync {
            self.rebootHomeManager()
        }
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

        accessories = home.accessories.map({ AccessoryInfo(accessory: $0)})
    
        home.accessories.forEach { accessory in
            accessory.delegate = self
            Task {
                await accessory.enableNotifications()
                await accessory.readValues()
            }
        }
        
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
