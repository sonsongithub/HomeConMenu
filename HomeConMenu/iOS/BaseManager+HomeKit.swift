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
    
    // service
    func accessory(_ accessory: HMAccessory, didUpdateNameFor service: HMService) {
        Logger.homeKit.info(#function)
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didUpdateNameFor room: HMRoom) {
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didRemove room: HMRoom) {
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didRemove group: HMServiceGroup) {
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didRemove service: HMService, from group: HMServiceGroup) {
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didUpdateNameFor group: HMServiceGroup) {
        Logger.homeKit.info(#function)
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didAdd room: HMRoom) {
        Logger.homeKit.info(#function)
        reloadAllItems()
    }
    
    func accessoryDidUpdateServices(_ accessory: HMAccessory) {
        Logger.homeKit.info(#function)
        reloadAllItems()
    }
    
    func accessory(_ accessory: HMAccessory, service: HMService, didUpdateValueFor characteristic: HMCharacteristic) {
        Logger.homeKit.info(#function)
        guard let obj = self.accessories.first(where: { info in
            return info.uniqueIdentifier == accessory.uniqueIdentifier
        }) else { return }
        for service in obj.services {
            for chara in service.characteristics {
                if chara.uniqueIdentifier == characteristic.uniqueIdentifier {
                    chara.value = characteristic.value
                    macOSController?.didUpdate(chracteristicInfo: chara)
                }
            }
        }
        reloadSceneStatus()
    }
    
    func homeManager(_ manager: HMHomeManager, didUpdate status: HMHomeManagerAuthorizationStatus) {
        if status.contains(.restricted) {
            Logger.app.error("HomeConMenu is not authorized to access HomeKit.")
            _ = macOSController?.openHomeKitAuthenticationError()
            let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.LaunchView")
            userActivity.title = "default"
            UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        } else {
            Logger.app.info("HomeConMenu is authorized to access HomeKit.")
        }
        macOSController?.didUpdate()
    }
    
    func home(_ home: HMHome, didAdd accessory: HMAccessory) {
        reloadAllItems()
    }
    
    func home(_ home: HMHome, didRemove accessory: HMAccessory) {
        reloadAllItems()
    }
    
    func homeManagerDidUpdatePrimaryHome(_ manager: HMHomeManager) {
        Logger.homeKit.info(#function)
        reloadAllItems()
    }
    
    func homeManagerDidUpdateHomes(_ manager: HMHomeManager) {
        Logger.homeKit.info(#function)
        reloadAllItems()
    }
}
