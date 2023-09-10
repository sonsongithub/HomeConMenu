//
//  LaunchWindowController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/10.
//

import AppKit

class LaunchWindowController: NSWindowController {
    
    init() {
        let vc = LaunchViewController(nibName: NSNib.Name("LaunchView"), bundle: nil)
        let window = NSWindow(contentViewController: vc)
        window.title = NSLocalizedString("Welcome to HomeConMenu", comment: "")
        window.styleMask.remove( [ .resizable ] )
        
        super.init(window: window)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
