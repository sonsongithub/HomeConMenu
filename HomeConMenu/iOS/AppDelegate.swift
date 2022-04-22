//
//  AppDelegate.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/02.
//

import UIKit
import HomeKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var baseManager: BaseManager?
    var mgr: HMHomeManager?
    var allPowerControllableAccessories: [HMAccessory] = []

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        baseManager = BaseManager()
        return true
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // this function is not called when launching.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

