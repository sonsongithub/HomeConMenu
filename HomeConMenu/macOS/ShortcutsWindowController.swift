//
//  ShortcutsWindowController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/07.
//

import Foundation
import AppKit
import KeyboardShortcuts

extension KeyboardShortcuts.Name {
    static let toggleUnicornMode = Self("toggleUnicornMode")
}

class ShortcutsWindowController: NSWindowController {
    
    @IBOutlet var customView: NSView?
    
    override func windowDidLoad() {
        super.windowDidLoad()
        print("windowDidLoad")
        
        let b = UserDefaults.standard.bool(forKey: "doesNotShowLaunchViewController")
        
        print("doesNotShowLaunchViewController=\(b)")
        
        let recorder = KeyboardShortcuts.RecorderCocoa(for: .toggleUnicornMode)
        recorder.frame = CGRect(x: 0, y: 0, width: 200, height: 40)
        self.customView?.addSubview(recorder)
    }

    override func close() {
        super.close()
        print("close")
    }
    
    
    
    deinit {
        print("deinit ShortcutsWindowController")
    }
}
