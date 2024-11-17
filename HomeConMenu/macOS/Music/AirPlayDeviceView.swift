//
//  AirPlayDeviceView.swift
//  MusicMenu
//
//  Created by Yuichi Yoshida on 2024/11/04.
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

import Cocoa

class AirPlayDeviceView : NSView {
    var name: String = ""
    
    @IBOutlet var deviceNameLabel: NSTextField?
    @IBOutlet var deviceVolumeSlider: NSSlider?
    @IBOutlet var enableButton: NSButton?
    @IBOutlet var icon: NSImageView?
    @IBOutlet var volumeImage: NSImageView?
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        let center = DistributedNotificationCenter.default()
        center.addObserver(self, selector: #selector(receiveNotification(_:)), name: NSNotification.Name("com.apple.Music.playerInfo"), object: nil)
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        let center = DistributedNotificationCenter.default()
        center.addObserver(self, selector: #selector(receiveNotification(_:)), name: NSNotification.Name("com.apple.Music.playerInfo"), object: nil)
    }
    
    static func create(frame frameRect: NSRect, name: String) -> AirPlayDeviceView? {
        var topLevelObjects: NSArray? = nil
        Bundle.main.loadNibNamed("AirPlayDeviceView", owner: self, topLevelObjects: &topLevelObjects)
        guard let view = topLevelObjects?.first(where: { $0 is NSView }) as? AirPlayDeviceView else {
            return nil
        }
        view.name = name
        view.frame = frameRect
        view.autoresizingMask = [.width, .height]
        
        view.update()
        return view
    }
    
    func update() {
        Task {
            guard let musicApp = SBApplication.musicApp else { return }
            guard let device = musicApp.AirPlayDevices?().first(where: { String($0.name ?? "") == self.name }) else { return }
            
            DispatchQueue.main.async {
                guard let device_select = device.selected else { return }
                
                if let stateButton = self.enableButton {
                    stateButton.state = device_select ? .on : .off
                }
                if let stateSlider = self.deviceVolumeSlider {
                    stateSlider.isHidden = !device_select
                    self.volumeImage?.isHidden = !device_select
                    stateSlider.integerValue = device.soundVolume ?? 0
                    self.volumeImage?.updateSoundVolume(with: stateSlider)
                }
            }
        }
    }
    
    @objc func receiveNotification(_ notification: NSNotification) {
        if let userInfo = notification.userInfo {
            if let message = userInfo["Player State"] as? String {
                if message == "Playing" {
                    self.update()
                }
                if message == "Paused" {
                    self.update()
                }
            }
        }
    }
    
    @IBAction func enableButtonClicked(_ sender: NSButton) {
        guard let musicApp = SBApplication.musicApp else { return }
        guard let device = musicApp.AirPlayDevices?().first(where: { String($0.name ?? "") == self.name }) else { return }
        device.setSelected?((sender.state == .on))
        self.update()
    }
    
    @IBAction func volumeSliderChanged(_ sender: NSSlider) {
        guard let musicApp = SBApplication.musicApp else { return }
        guard let device = musicApp.AirPlayDevices?().first(where: { String($0.name ?? "") == self.name }) else { return }
        device.setSoundVolume?(sender.integerValue)
        self.volumeImage?.updateSoundVolume(with: sender)
    }
}
