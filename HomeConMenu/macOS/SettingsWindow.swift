//
//  SettingsWindow.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/08.
//

import AppKit

final class SettingsWindow: NSPanel {
    
    // MARK: Panel Methods
    
    /// disable "Hide Toolbar" menu item
    override func validateMenuItem(_ menuItem: NSMenuItem) -> Bool {
        
        switch menuItem.action {
            case #selector(toggleToolbarShown):
                return false
                
            default:
                return super.validateMenuItem(menuItem)
        }
    }
    
    deinit {
        print("SettingsWindow - deinit")
    }
    
}
