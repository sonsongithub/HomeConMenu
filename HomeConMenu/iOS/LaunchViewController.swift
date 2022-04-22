//
//  LaunchViewController.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/04/20.
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
