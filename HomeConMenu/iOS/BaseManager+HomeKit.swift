//
//  BaseManager+HomeKit.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/06.
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

extension BaseManager {
    
    // MARK: HMHomeDelegate - add
    
    func home(_ home: HMHome, didAdd accessory: HMAccessory) {
        Logger.homeKit.info("home:didAdd:accessory")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func home(_ home: HMHome, didAdd actionSet: HMActionSet) {
        Logger.homeKit.info("home:didAdd:actionSet")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func home(_ home: HMHome, didAdd room: HMRoom) {
        Logger.homeKit.info("home:didAdd:room")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    // MARK: HMHomeDelegate - remove
    
    func home(_ home: HMHome, didRemove accessory: HMAccessory) {
        Logger.homeKit.info("home:didRemove:accessory")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func home(_ home: HMHome, didRemove actionSet: HMActionSet) {
        Logger.homeKit.info("home:didRemove:actionSet")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func home(_ home: HMHome, didRemove room: HMRoom) {
        Logger.homeKit.info("home:didRemove:room")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func home(_ home: HMHome, didRemove group: HMServiceGroup) {
        Logger.homeKit.info("home:didRemove:group")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func home(_ home: HMHome, didRemove service: HMService, from group: HMServiceGroup) {
        Logger.homeKit.info("home:didRemove:from:")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    // MARK: HMHomeDelegate - update
    
    func home(_ home: HMHome, didUpdateNameFor group: HMServiceGroup) {
        Logger.homeKit.info("home:didUpdateNameFor:group")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func home(_ home: HMHome, didUpdateNameFor room: HMRoom) {
        Logger.homeKit.info("home:didUpdateNameFor:room")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    // MARK: HMAccessoryDelegate
    
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        Logger.homeKit.info("accessoryDidUpdateServices:")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func accessory(_ accessory: HMAccessory, didUpdateNameFor service: HMService) {
        Logger.homeKit.info("accessory:didUpdateNameFor:")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        Logger.homeKit.info("accessory: \(accessory.name) service: \(service.typeAsString) didUpdateValueFor: \(characteristic.typeAsString)")
        
        // check whether a associated service has been updated.
        let incommingServiceInfo = ServiceInfo(service: service)
        if let existingServiceInfo = self
            .accessories
            .map({ $0.services })
            .flatMap({ $0 }).first(where: { $0.uniqueIdentifier == incommingServiceInfo.uniqueIdentifier }) {
            if existingServiceInfo.associatedServiceType != incommingServiceInfo.associatedServiceType {
                fetchFromHomeKitAndReloadMenuExtra()
                return
            }
        }
        macOSController?.updateMenuItemsRelated(to: characteristic.uniqueIdentifier, using: characteristic.value as Any)
    }
    
    // MARK: HMHomeManagerDelegate
    
    /// When invoked for the first time, this method is called after a confirmation dialog appears and the user interacts with the dialog because Accessibility to HomeKit is not allowed. 
    /// This method is called whether or not the user grants access in the dialog.
    /// If the user then grants access, HMHomeManager moves and homeManagerDidUpdateHomes is called.
    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
        Logger.homeKit.info("homeManager:didUpdate:")
        if status.contains(.restricted) {
            Logger.homeKit.error("HomeConMenu is not authorized to access HomeKit.")
            _ = macOSController?.openHomeKitAuthenticationError()
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        } else {
            Logger.homeKit.info("HomeConMenu is authorized to access HomeKit.")
        }
        macOSController?.reloadMenuExtra()
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        Logger.homeKit.info("homeManagerDidUpdatePrimaryHome")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        Logger.homeKit.info("homeManagerDidUpdateHomes")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func homeManager(_ manager: HMHomeManager, didAdd home: HMHome) {
        Logger.homeKit.info("homeManager:didAdd:home")
        fetchFromHomeKitAndReloadMenuExtra()
    }
    
    func homeManager(_ manager: HMHomeManager, didRemove home: HMHome) {
        Logger.homeKit.info("homeManager:didRemove:home")
        fetchFromHomeKitAndReloadMenuExtra()
    }
}
