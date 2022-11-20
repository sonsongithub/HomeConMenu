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
                            characteristic.enableNotification(true, completionHandler: { error in
                                if let error = error {
//                                    print("\(characteristic.characteristicType.description) - \(error)")
                                }
                            })
                            try await characteristic.readValue()
//
                            print(characteristic.value)
//
//                            let char = HCCharacteristic(with: characteristic)
//
//                            let data = try encoder.encode(char)
//                            guard let jsonString = String(data: data, encoding: .utf8) else {
//                                throw NSError(domain: "", code: 0)
//                            }
//                            macOSController?.post(string: jsonString, name: .to_char_notify)
////                            print("OK - \(characteristic.characteristicType)")
                        } catch {
//                            print(error)
                        }
                    }
                }
            }
        }
        let com = HCCommunication(with: home)
        
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(com)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "", code: 0)
            }
            macOSController?.post(string: jsonString)
        } catch {
            print(error)
        }
    }

}
