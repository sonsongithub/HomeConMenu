//
//  LaunchViewController.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/04/20.
//

import UIKit

class CheckButton: UIButton {
    var isChecked = false {
        didSet {
            if isChecked {
                self.setImage(UIImage(systemName: "checkmark.square"), for: .normal)
            } else {
                self.setImage(UIImage(systemName: "square"), for: .normal)
            }
        }
    }
}

class LaunchViewController: UIViewController {
    @IBOutlet var button: CheckButton?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        button?.tintColor = .systemBlue

        let LaunchIsChecked = UserDefaults.standard.bool(forKey: "LaunchIsChecked")
        button?.isChecked = LaunchIsChecked
    }
    
    @IBAction func didPush(sender: UIButton) {
        if let button = button {
            button.isChecked = !button.isChecked
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        if let button = button {
            print(button.isChecked)
            UserDefaults.standard.set(button.isChecked, forKey: "LaunchIsChecked")
            UserDefaults.standard.synchronize()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.baseManager?.ios2mac?.centeringWindows()
        }
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.baseManager?.ios2mac?.bringToFront()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.baseManager?.ios2mac?.centeringWindows()
        }
    }
    
}
