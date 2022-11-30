//
//  BaseManager+Codable.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/10/09.
//

import Foundation
import HomeKit
import os
//import CryptoSwift

extension BaseManager {
    
    func read_all_values() {
        guard let home = self.homeManager?.primaryHome else {
            return
        }
        home.accessories.forEach { accessory in
            accessory.services.forEach { service in
                service.characteristics.filter({ $0.isSupported }).forEach { characteristic in
                    Task {
                        do {
                            try await characteristic.readValue()
                            let char = HCCharacteristic(with: characteristic)
                            char.reachable = true
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(char)
                            
                            guard let jsonString = String(data: data, encoding: .utf8) else { throw HomeConMenuError.jsonCannotBeConvertedToString}
                            macOSController?.post(string: jsonString, name: .didUpdateCharacteristic)
                        } catch {
                            let char = HCCharacteristic(with: characteristic)
                            char.reachable = false
                            let encoder = JSONEncoder()
                            let data = try encoder.encode(char)
                            guard let jsonString = String(data: data, encoding: .utf8) else { throw HomeConMenuError.jsonCannotBeConvertedToString}
                            macOSController?.post(string: jsonString, name: .didUpdateCharacteristic)
                        }
                    }
                }
            }
        }
    }
    
    func read_actionSet() {
        guard let home = self.homeManager?.primaryHome else {
            return
        }
        let actionSets = home.actionSets
            .filter({ $0.isHomeKitScene })
            .map({HCActionSet(actionSet: $0)})
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(actionSets)
            guard let jsonString = String(data: data, encoding: .utf8) else { throw HomeConMenuError.jsonCannotBeConvertedToString}
            macOSController?.post(string: jsonString, name: .didUpdateActionSets)
        } catch {
            print(error)
        }
    }
    
    func reloadAllItems2() {
        
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
        
        home.accessories.forEach { accessory in
            
            accessory.delegate = self
            
            accessory.services.forEach { service in
                service.characteristics.forEach { characteristic in
                    Task {
                        do {
                            try await characteristic.enableNotification(true)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
        let com = HCCommunication(with: home)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(com)
            guard let jsonString = String(data: data, encoding: .utf8) else { throw HomeConMenuError.jsonCannotBeConvertedToString }
            macOSController?.post(string: jsonString)
        } catch {
            print(error)
        }
        
        read_all_values()
        read_actionSet()
    }

}
