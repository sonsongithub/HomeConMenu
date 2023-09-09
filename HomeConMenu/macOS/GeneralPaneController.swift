//
//  GeneralPaneController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/08.
//

import Foundation
import AppKit

class GeneralPaneController: NSViewController {
    @IBOutlet var doesNotShowLaunchViewController: NSButton?
    @IBOutlet var allowDuplicatingServices: NSButton?
    @IBOutlet var useScenes: NSButton?
    
    override func viewWillAppear() {
        super.viewWillAppear()
        if let value = UserDefaults.standard.object(forKey: "doesNotShowLaunchViewController") as? Bool {
            doesNotShowLaunchViewController?.state = value ? .on : .off
        } else {
            doesNotShowLaunchViewController?.state = .off
        }
        
        if let value = UserDefaults.standard.object(forKey: "allowDuplicatingServices") as? Bool {
            allowDuplicatingServices?.state = value ? .on : .off
        } else {
            allowDuplicatingServices?.state = .off
        }
    
        if let value = UserDefaults.standard.object(forKey: "useScenes") as? Bool {
            useScenes?.state = value ? .on : .off
        } else {
            useScenes?.state = .off
        }
    }
    
    @IBAction func didChangeDoesNotShowLaunchViewController(sender: NSButton) {
        print(#function)
        UserDefaults.standard.set(sender.state == .on, forKey: "doesNotShowLaunchViewController")
    }
    
    @IBAction func didChangeAllowDuplicatingServices(sender: NSButton) {
        print(#function)
        UserDefaults.standard.set(sender.state == .on, forKey: "allowDuplicatingServices")
    }
    
    @IBAction func didChangeUseScenes(sender: NSButton) {
        print(#function)
        UserDefaults.standard.set(sender.state == .on, forKey: "useScenes")
    }
}
