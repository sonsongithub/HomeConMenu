//
//  PreferenceModel.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/07.
//

import Foundation

class PreferenceModel: ObservableObject {
    @Published var doesNotShowLaunchViewController: Bool {
        didSet {
            UserDefaults.standard.set(doesNotShowLaunchViewController, forKey: "doesNotShowLaunchViewController")
        }
    }
    
    @Published var allowDuplicatingServices: Bool {
        didSet {
            UserDefaults.standard.set(allowDuplicatingServices, forKey: "allowDuplicatingServices")
        }
    }
    
    @Published var useScenes: Bool {
        didSet {
            UserDefaults.standard.set(useScenes, forKey: "useScenes")
        }
    }
    
    init() {
        if let doesNotShowLaunchViewController = UserDefaults.standard.object(forKey: "doesNotShowLaunchViewController") as? Bool {
            self.doesNotShowLaunchViewController = doesNotShowLaunchViewController
        } else {
            self.doesNotShowLaunchViewController = false
        }
        
        if let allowDuplicatingServices = UserDefaults.standard.object(forKey: "allowDuplicatingServices") as? Bool {
            self.allowDuplicatingServices = allowDuplicatingServices
        } else {
            self.allowDuplicatingServices = false
        }
    
        if let useScenes = UserDefaults.standard.object(forKey: "useScenes") as? Bool {
            self.useScenes = useScenes
        } else {
            self.useScenes = false
        }
    }
}
