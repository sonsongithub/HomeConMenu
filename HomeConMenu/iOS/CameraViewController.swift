//
//  CameraViewController.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/11.
//

import Foundation
import UIKit
import HomeKit

class CameraViewController: UIViewController, HMCameraStreamControlDelegate {
    
    var cameraView: HMCameraView?
    var cameraProfile: HMCameraProfile?

    override func viewWillDisappear(_ animated: Bool) {
        if let streamControl = cameraProfile?.streamControl {
            streamControl.delegate = nil
            streamControl.stopStream()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.baseManager?.ios2mac?.bringToFront()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let indicator = UIActivityIndicatorView(style: .large)
        self.view.addSubview(indicator)
        indicator.translatesAutoresizingMaskIntoConstraints = false
        
        self.view.addConstraints([
            self.view.safeAreaLayoutGuide.centerXAnchor.constraint(equalTo: indicator.centerXAnchor, constant: 0),
            self.view.safeAreaLayoutGuide.centerYAnchor.constraint(equalTo: indicator.centerYAnchor, constant: 0)
        ])
        indicator.startAnimating()
        guard let cameraProfile = cameraProfile else { return }
        
        cameraProfile.streamControl?.delegate = self
        let cameraView = HMCameraView()
        cameraView.frame = self.view.bounds
        cameraView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.view.addSubview(cameraView)
        self.cameraView = cameraView

        cameraProfile.streamControl?.startStream()
        
        
        self.view.setNeedsLayout()
    }
    
    func cameraStreamControlDidStartStream(_ cameraStreamControl: HMCameraStreamControl) {
        guard let cameraView = cameraView else { return }
        cameraView.cameraSource = cameraStreamControl.cameraStream
    }
}

