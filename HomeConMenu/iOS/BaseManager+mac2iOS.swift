//
//  BaseManager+mac2iOS.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2023/12/10.
//

import Foundation
import HomeKit
import os

// MARK: Extension for mac2iOS

extension BaseManager {
    
    /// Restart HKHomeManager included in BaseManager.
    func rebootHomeManager() {
        Logger.app.info("rebootHomeManager")
        homeManager?.delegate = nil
        homeManager = HMHomeManager()
        homeManager?.delegate = self
    }
    
    /// Close windowScene of MacCatalyst.
    /// In MacCatalyst, when user closes a window, runtime does not dispose UIWindow and UIWindowScene.
    /// So, this app receives window close event using the macOS bundle, and explicitly closes them.
    /// This method is called from macOS bundle when it receives any NSWindow closing notification.
    /// - Parameter windows: Array of windows to be closed. The type is Any because the macOS bundle can not handle UIWindow.
    func close(windows: [Any]) {
        let uiWindows = windows.compactMap({ $0 as? UIWindow })
        UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .filter({ $0.windows.count > 0 })
            .forEach { windowScene in
                windowScene.windows.forEach { window in
                    if uiWindows.contains(where: { $0 == window }) {
                    UIApplication.shared.requestSceneSessionDestruction(windowScene.session, options: nil)
                    window.rootViewController = nil
                    Logger.app.info("close UIWindow(\(window)")
                }
            }
        }
    }
    
    /// Get value from service whose characteristic is to write value.
    /// - Parameter uniqueIdentifier: UUID of the service.
    /// - Returns: Array of values.
    func getTargetValues(of uniqueIdentifier: UUID) throws -> [Any] {
        guard let home = self.homeManager?.usedHome(with: self.homeUniqueIdentifier) else { throw HomeConMenuError.primaryHomeNotFound }
        guard let actionSet = home.actionSets.first(where: { $0.uniqueIdentifier == uniqueIdentifier })
        else { throw HomeConMenuError.actionSetNotFound }
        let writeActions = actionSet.actions.compactMap( { $0 as? HMCharacteristicWriteAction<NSCopying> })
        
        return writeActions.map({$0.targetValue as Any})
    }
    
    /// Execute action set whose unique identifier is specified by `uniqueIdentifier`.
    /// - Parameter uniqueIdentifier: UUID of the action set.
    func executeActionSet(uniqueIdentifier: UUID) {
        guard let home = homeManager?.usedHome(with: self.homeUniqueIdentifier) else { return }
        guard let actionSet = home.actionSets.first(where: { $0.uniqueIdentifier == uniqueIdentifier }) else { return }
        guard !actionSet.isExecuting else { Logger.app.error("This action set has beeen already executing.");return }
        
        Task.detached {
            do {
                try await home.executeActionSet(actionSet)
                DispatchQueue.main.async {
                    for writeAction in actionSet.actions.compactMap({ $0 as? HMCharacteristicWriteAction<NSCopying> }) {
                        self.macOSController?.updateItems(of: writeAction.uniqueIdentifier, value: writeAction.targetValue)
                    }
                }
            } catch {
                Logger.homeKit.error("Can not execute actionset - \(error.localizedDescription)")
            }
        }
    }
    
    /// Request to read value of characteristic whose unique identifier is specified by `uniqueIdentifier`.
    /// Reading value is not execute synchronously.
    /// - Parameter uniqueIdentifier: UUID of the characteristic.
    func readCharacteristic(of uniqueIdentifier: UUID) {
        guard let characteristic = homeManager?.getCharacteristic(from: self.homeUniqueIdentifier, with: uniqueIdentifier) else { return }
        Task {
           do {
               try await characteristic.readValue()
               DispatchQueue.main.async {
                   self.macOSController?.updateItems(of: uniqueIdentifier, value: characteristic.value as Any)
               }
           } catch {
               Logger.homeKit.error("Can not read value - \(error.localizedDescription)")
               DispatchQueue.main.async {
                   self.macOSController?.updateItems(of: uniqueIdentifier, isReachable: false)
               }
           }
        }
    }
    
    /// Request to write value of characteristic whose unique identifier is specified by `uniqueIdentifier`.
    /// - Parameters: uniqueIdentifier: UUID of the characteristic.
    /// - Parameters: object: Value to write.
    func setCharacteristic(of uniqueIdentifier: UUID, object: Any) {
        guard let characteristic = homeManager?.getCharacteristic(from: self.homeUniqueIdentifier, with: uniqueIdentifier) else { return }
        Task.detached {
            do {
                try await characteristic.writeValue(object)
                DispatchQueue.main.async {
                    self.macOSController?.updateItems(of: uniqueIdentifier, value: object)
                }
            } catch {
                Logger.homeKit.error("Can not write value - \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self.macOSController?.updateItems(of: uniqueIdentifier, isReachable: false)
                }
            }
        }
    }
    
    /// Return value of characteristic whose unique identifier is specified by `uniqueIdentifier`.
    /// - Parameter uniqueIdentifier: UUID of the characteristic.
    /// - Returns: Value of the characteristic.
    func getCharacteristic(of uniqueIdentifier: UUID) throws -> Any {
        guard let characteristic = homeManager?.getCharacteristic(from: self.homeUniqueIdentifier, with: uniqueIdentifier)
        else { throw HomeConMenuError.characteristicNotFound }
        guard characteristic.value != nil else { throw HomeConMenuError.characteristicValueNil }
        return characteristic.value as Any
    }
    
    /// Open camera whose unique identifier is specified by `uniqueIdentifier`.
    /// - Parameter uniqueIdentifier: UUID of the camera.
    func openCamera(uniqueIdentifier: UUID) {
        guard let accessory = self.homeManager?.getAccessory(from: self.homeUniqueIdentifier, with: uniqueIdentifier) else { return }
        guard let cameraProfile = accessory.cameraProfiles?.first else { return }
        guard cameraProfile.streamControl?.delegate == nil else { return }
        
        let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.openCamera")
        userActivity.title = "default"
        userActivity.addUserInfoEntries(from: ["uniqueIdentifier": uniqueIdentifier])
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        
        self.macOSController?.bringToFront()
    }
    
    /// Open web view controller to show acknowledgement.
    func openAcknowledgement() {
        let userActivity = NSUserActivity(activityType: "com.sonson.HomeMenu.Acknowledgement")
        userActivity.title = "default"
        UIApplication.shared.requestSceneSessionActivation(nil, userActivity: userActivity, options: nil, errorHandler: nil)
        self.macOSController?.bringToFront()
    }
}