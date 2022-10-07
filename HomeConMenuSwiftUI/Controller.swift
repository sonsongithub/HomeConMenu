//
//  Controller.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/09/26.
//

import Foundation
import AppKit

class Controller : NSScriptCommand {
    
    
    override func performDefaultImplementation() -> Any? {
        print(self.directParameter)
        guard let message = self.directParameter as? String else {
            print("error")
            return false
        }
        
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Get data", comment: "")
        alert.informativeText = NSLocalizedString(message, comment:"")
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        _ = alert.runModal()
        
        return true
    }
        
    public func MyAppScriptingSetValue(_ value:Any, forKey:String) {
        NSLog("[APPLESCRIPT] Setting value for \(forKey): \(String(describing:value))")
        
        if forKey == "savedString" {
            return
        }
        
        if forKey == "savedNumber" {
            return
        }
    }

}


