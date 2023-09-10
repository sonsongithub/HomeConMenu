//
//  LaunchViewController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/09.
//

import AppKit

class LaunchViewController: NSViewController {
    @IBOutlet var button: NSButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.didChangeUserDefaults), name: UserDefaults.didChangeNotification, object: nil)
    }
    
    @IBAction func didChangeShowLaunchViewController(sender: NSButton) {
        print(#function)
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
