//
//  HelpViewController.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/04/19.
//

import UIKit

class HelpViewController: UIViewController {
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
    
    @IBAction func pushOK(sender: UIButton) {
        UIApplication.shared.connectedScenes.forEach { (scene) in
            if let uiscene = scene as? UIWindowScene {
                uiscene.windows.forEach { (window) in
                    if window.rootViewController == self {
                        UIApplication.shared.requestSceneSessionDestruction(uiscene.session, options: .none) { (error) in
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    @IBAction func pushCheck(sender: UIButton) {
        if let url = URL(string: "https://www.apple.com/jp/ios/home/") {
            UIApplication.shared.open(url)
        }
    }
}

