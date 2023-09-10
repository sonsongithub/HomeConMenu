//
//  InformationPaneController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/09.
//

import AppKit
import WebKit

class InformationPaneController: NSViewController {
    var mac2ios: mac2iOS?
    @IBOutlet var versionField: NSTextField?
    
    let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?.?.?"
    let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"
    
    @IBAction func openGithub(sender: Any?) {
        NSWorkspace.shared.open(URL(string: "https://github.com/sonsongithub/HomeConMenu")!)
    }
    
    @IBAction func becomeSponsor(sender: Any?) {
        NSWorkspace.shared.open(URL(string: "https://github.com/sponsors/sonsongithub")!)
    }
    
    @IBAction func openAcknowledgement(sender: Any?) {
        if let mac2ios = mac2ios {
            mac2ios.openWebView()
        }
        NSApp.activate(ignoringOtherApps: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        versionField?.stringValue = "\(version) (\(build))"
    }
}
