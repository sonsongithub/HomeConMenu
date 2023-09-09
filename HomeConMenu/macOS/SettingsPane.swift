//
//  SettingsPane.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/08.
//

import Foundation

enum SettingsPane: String, CaseIterable {
    
    case general
    case shortcuts
    
    /// Localized label.
    var label: String {
        
        switch self {
            case .general:
                return String(localized: "General")
            case .shortcuts:
                return String(localized: "Key Bindings")
        }
    }
    
    
    /// Symbol image name.
    var symbolName: String {
        
        switch self {
            case .general:
                return "gearshape"
            case .shortcuts:
                return "keyboard"
        }
    }
}
