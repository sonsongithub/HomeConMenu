//
//  LaunchViewController.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/04/20.
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

import UIKit

class LaunchViewController: UIViewController {
    @IBOutlet var button: UISwitch?
    @IBOutlet var label: UILabel?
    
    @objc func userDidTapLabel(tapGestureRecognizer: UITapGestureRecognizer) {
        if let button = button {
            button.isOn = !button.isOn
            UserDefaults.standard.set(button.isOn, forKey: "doesNotShowLaunchViewController")
            UserDefaults.standard.synchronize()
        }
    }
    
    @IBAction func didChange(sender: UISwitch) {
        if let button = button {
            UserDefaults.standard.set(button.isOn, forKey: "doesNotShowLaunchViewController")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label?.isUserInteractionEnabled = true
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.userDidTapLabel(tapGestureRecognizer:)))
        label?.addGestureRecognizer(tapGesture)
        
//        "x-apple.systempreferences:com.apple.preference.security?Privacy_HomeKit"
    }
    
    override func viewWillDisappear(_ animated: Bool) {
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.baseManager?.ios2mac?.centeringWindows()
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.baseManager?.ios2mac?.bringToFront()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        button?.tintColor = .systemBlue
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.baseManager?.ios2mac?.centeringWindows()
            button?.isOn = UserDefaults.standard.bool(forKey: "doesNotShowLaunchViewController")
        }
    }
    
}
