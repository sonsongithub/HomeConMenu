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
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didAdd actionSet: HMActionSet) {
        Logger.homeKit.info("home:didAdd:actionSet")
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didAdd room: HMRoom) {
        Logger.homeKit.info("home:didAdd:room")
        reloadAllItems()
    }
    
    // MARK: HMHomeDelegate - remove
    
    func home(_ home: HMHome, didRemove accessory: HMAccessory) {
        Logger.homeKit.info("home:didRemove:accessory")
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didRemove actionSet: HMActionSet) {
        Logger.homeKit.info("home:didRemove:actionSet")
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didRemove room: HMRoom) {
        Logger.homeKit.info("home:didRemove:room")
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didRemove group: HMServiceGroup) {
        Logger.homeKit.info("home:didRemove:group")
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didRemove service: HMService, from group: HMServiceGroup) {
        Logger.homeKit.info("home:didRemove:from:")
        reloadAllItems()
    }
    
    // MARK: HMHomeDelegate - update
    
    func home(_ home: HMHome, didUpdateNameFor group: HMServiceGroup) {
        Logger.homeKit.info("home:didUpdateNameFor:group")
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didUpdateNameFor room: HMRoom) {
        Logger.homeKit.info("home:didUpdateNameFor:room")
        reloadAllItems()
    }
    
    // MARK: HMAccessoryDelegate
    
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        Logger.homeKit.info("accessoryDidUpdateServices:")
        reloadAllItems()
    }
    
    func accessory(_ accessory: HMAccessory, didUpdateNameFor service: HMService) {
        Logger.homeKit.info("accessory:didUpdateNameFor:")
        reloadAllItems()
    }
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        Logger.homeKit.info("accessory:service:didUpdateValueFor:")
        guard let _ = self.accessories.first(where: { info in
            return info.uniqueIdentifier == accessory.uniqueIdentifier
        }) else { return }
        macOSController?.updateItems(of: characteristic.uniqueIdentifier, value: characteristic.value as Any)
    }
    
    // MARK: HMHomeManagerDelegate
    
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
        macOSController?.reloadAllMenuItems()
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        Logger.homeKit.info("homeManagerDidUpdatePrimaryHome")
        reloadAllItems()
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        Logger.homeKit.info("homeManagerDidUpdateHomes")
        reloadAllItems()
    }
}
