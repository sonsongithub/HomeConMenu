//
//  SceneDelegate.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/02.
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

import UIKit
import SwiftUI
import os

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func showCameraWindow(windowScene: UIWindowScene, connectionOptions: UIScene.ConnectionOptions) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
    
        if let uniqueIdentifier = connectionOptions.userActivities.first?.userInfo?["uniqueIdentifier"] as? UUID {
            
            guard let accessory = appDelegate.baseManager?.homeManager?.getAccessory(from: appDelegate.baseManager?.homeUniqueIdentifier, with: uniqueIdentifier) else { return }
            
            guard let cameraProfile = accessory.cameraProfiles?.first else { return }
            
            let window = UIWindow(windowScene: windowScene)
            self.window = window
            let vc = CameraViewController(nibName: nil, bundle: nil)
            self.window?.rootViewController = vc
            vc.cameraProfile = cameraProfile
            
            windowScene.title = accessory.name
            windowScene.userActivity = connectionOptions.userActivities.first
            
            self.window?.makeKeyAndVisible()
        }
    }
    
    func showAcknowledgementWindow(windowScene: UIWindowScene, connectionOptions: UIScene.ConnectionOptions) {

        let url = Bundle.main.url(forResource: "Acknowledgments", withExtension: "html")!
        let vc = WebViewController(fileURL: url)
        
        let window = UIWindow(windowScene: windowScene)
        self.window = window
        self.window?.rootViewController = vc
        
        windowScene.userActivity = connectionOptions.userActivities.first

        self.window?.makeKeyAndVisible()
    }
    
    func forceCloseDummyViewController() {
        let windowScenes = DummyViewController.windowScenesIncludingThisClass()
        windowScenes.forEach { windowScene in
            Logger.app.info("force close DummyViewController")
            UIApplication.shared.requestSceneSessionDestruction(windowScene.session, options: nil)
            windowScene.windows.forEach { window in
                window.rootViewController = nil
            }
        }
    }
    
    func windowScene(_ windowScene: UIWindowScene, didUpdate previousCoordinateSpace: UICoordinateSpace, interfaceOrientation previousInterfaceOrientation: UIInterfaceOrientation, traitCollection previousTraitCollection: UITraitCollection) {
        forceCloseDummyViewController()
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
            showCameraWindow(windowScene: windowScene, connectionOptions: connectionOptions)
        case ("com.sonson.HomeMenu.Acknowledgement", "default"):
            showAcknowledgementWindow(windowScene: windowScene, connectionOptions: connectionOptions)
            #if targetEnvironment(macCatalyst)
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 700, height: 720)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 700, height: 720)
            #endif
        default:
            #if targetEnvironment(macCatalyst)
            // This is a workaround to hide the view controller which is forced to appear when launching.
            windowScene.sizeRestrictions?.minimumSize = CGSize(width: 1, height: 1)
            windowScene.sizeRestrictions?.maximumSize = CGSize(width: 1, height: 1)
            #endif
        }
    }
}

