//
//  LaunchViewController.swift
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

class LaunchViewController: NSViewController {
    @IBOutlet var button: NSButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeUserDefaults), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @IBAction func didChangeShowLaunchViewController(sender: NSButton) {
        UserDefaults.standard.set(sender.state == .on, forKey: "showLaunchViewController")
    }
    
    @IBAction func didChangeUserDefaults(notification: Notification) {
        if let value = UserDefaults.standard.object(forKey: "showLaunchViewController") as? Bool {
            button?.state = value ? .on : .off
        } else {
            UserDefaults.standard.setValue(true, forKey: "showLaunchViewController")
            button?.state = .on
        }
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        if let value = UserDefaults.standard.object(forKey: "showLaunchViewController") as? Bool {
            button?.state = value ? .on : .off
        } else {
            UserDefaults.standard.setValue(true, forKey: "showLaunchViewController")
            button?.state = .on
        }
    }
}
