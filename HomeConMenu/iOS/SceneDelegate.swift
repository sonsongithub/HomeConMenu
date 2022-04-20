//
//  SceneDelegate.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/02.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func openCameraView(windowScene: UIWindowScene, connectionOptions: UIScene.ConnectionOptions) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
        if let uniqueIdentifier = connectionOptions.userActivities.first?.userInfo?["uniqueIdentifier"] as? UUID {
            guard let accesory = appDelegate.baseManager?.homeManager?.getAccessory(with: uniqueIdentifier) else { return }
            
            guard let cameraProfiles = accesory.cameraProfiles else { return }
            
            for profile in cameraProfiles {
                print(profile)
            }
            
            guard let cameraProfile = accesory.cameraProfiles?.first else { return }
            print(cameraProfile)
            
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            let vc = CameraViewController(nibName: nil, bundle: nil)
            self.window?.rootViewController = vc
            vc.cameraProfile = cameraProfile
            
            windowScene.title = accesory.name
            windowScene.userActivity = connectionOptions.userActivities.first
            
            self.window?.makeKeyAndVisible()
        }
    }
    
    func openHelpView(windowScene: UIWindowScene, connectionOptions: UIScene.ConnectionOptions) {
        
        if let vc = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "LaunchViewController") as? LaunchViewController {
            print(vc)
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            self.window?.rootViewController = vc
            
            windowScene.userActivity = connectionOptions.userActivities.first

            self.window?.makeKeyAndVisible()
        }
    }

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {

        guard let windowScene = (scene as? UIWindowScene) else { return }
        let activity = connectionOptions.userActivities.first

        switch (activity?.activityType, activity?.title) {
        case ("com.sonson.HomeMenu.openCamera", "default"):
            #if targetEnvironment(macCatalyst)
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 320, height: 240)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 320, height: 240)
            #endif
            openCameraView(windowScene: windowScene, connectionOptions: connectionOptions)
        case ("com.sonson.HomeMenu.help", "default"):
            openHelpView(windowScene: windowScene, connectionOptions: connectionOptions)
            #if targetEnvironment(macCatalyst)
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 700, height: 550)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 700, height: 550)
            #endif
        default:
            #if targetEnvironment(macCatalyst)
            // This is a workaround to hide the view controller which is forced to appear when launching.
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 1, height: 1)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 1, height: 1)
            #endif
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
    }

    func sceneWillResignActive(_ scene: UIScene) {
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // check uiscene.configuration.name, here, whether the view controller is `ViewController` or not.ｔ
//        // dispose the window which will be opened when launchnig, here
//        guard let windowScene = (scene as? UIWindowScene) else { return }
//        let activity = windowScene.userActivity
//        switch (activity?.activityType, activity?.title) {
//        case ("com.sonson.HomeMenu.openCamera", "default"):
//            // default, do nothing
//            do {}
//        default:
//            UIApplication.shared.requestSceneSessionDestruction(windowScene.session, options: .none) { (error) in
//                print(error)
//            }
//        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
    }
}

