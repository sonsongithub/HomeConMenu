//
//  InformationPaneController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/09.
//

import AppKit
import WebKit

class InformationPaneController: NSViewController {
    
    @IBAction func openGithub(sender: Any?) {
        NSWorkspace.shared.open(URL(string: "https://github.com/sonsongithub/HomeConMenu")!)
    }
    
    @IBAction func becomeSponsor(sender: Any?) {
        NSWorkspace.shared.open(URL(string: "https://github.com/sponsors/sonsongithub")!)
    }
    
    @IBAction func openAcknowledgement(sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
    }
}
