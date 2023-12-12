//
//  InformationPaneController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/09.
//
//  MIT License
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
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
    
    @IBAction func openIssueTracker(sender: Any?) {
        NSWorkspace.shared.open(URL(string: "https://github.com/sonsongithub/HomeConMenu/issues")!)
    }
    
    @IBAction func openAcknowledgement(sender: Any?) {
        if let mac2ios = mac2ios {
            mac2ios.openAcknowledgement()
        }
        NSApp.activate(ignoringOtherApps: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
#if DEBUG
        versionField?.stringValue = "\(version) (\(build)) Debug"
#else
        versionField?.stringValue = "\(version) (\(build))"
#endif
    }
}
