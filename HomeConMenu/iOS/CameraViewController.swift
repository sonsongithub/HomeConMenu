//
//  CameraViewController.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/11.
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

import Foundation
import UIKit
import HomeKit
import os

class CameraViewController: UIViewController, HMCameraStreamControlDelegate {
    
    var cameraView: HMCameraView?
    var cameraProfile: HMCameraProfile?
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        Logger.app.info("CameraViewController - init")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        Logger.app.info("CameraViewController - deinit")
    }

    override func viewWillDisappear(_ animated: Bool) {
        if let streamControl = cameraProfile?.streamControl {
            streamControl.delegate = nil
            streamControl.stopStream()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        appDelegate.baseManager?.macOSController?.bringToFront()
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

