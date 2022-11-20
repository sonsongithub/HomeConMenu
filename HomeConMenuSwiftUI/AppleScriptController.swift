//
//  AppleScriptController.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/10.
//

import Foundation
import AppKit

class AppleScriptController : NSScriptCommand {
    
    
    override init(commandDescription commandDef: NSScriptCommandDescription) {
        super.init(commandDescription: commandDef)
    }
        
    override func performDefaultImplementation() -> Any? {
        guard let message = self.directParameter as? String else {
            return false
        }
        HomeConMenuSwiftUIApp.shared.sharedKey = message
        return true
    }
}

