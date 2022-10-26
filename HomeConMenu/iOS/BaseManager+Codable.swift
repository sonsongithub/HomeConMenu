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
