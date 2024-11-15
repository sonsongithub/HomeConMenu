//
//  MusicPlayerViewController.swift
//  HomeConMenu
//
//  Created by sonson on 2024/11/15.
//

import Cocoa

extension NSImageView {
    func updateSoundVolume(with slider: NSSlider) {
        if slider.integerValue == 0 {
            self.image = NSImage.init(systemSymbolName: "speaker", accessibilityDescription: nil)
        } else if slider.integerValue < 33 {
            self.image = NSImage.init(systemSymbolName: "speaker.wave.1", accessibilityDescription: nil)
        } else if slider.integerValue < 66 {
            self.image = NSImage.init(systemSymbolName: "speaker.wave.2", accessibilityDescription: nil)
        } else {
            self.image = NSImage.init(systemSymbolName: "speaker.wave.3", accessibilityDescription: nil)
        }
    }
}

class MusicPlayerViewController: NSViewController {
    
    @IBOutlet var playButton: NSButton?
    @IBOutlet var nextButton: NSButton?
    @IBOutlet var prevButton: NSButton?
    @IBOutlet var volumeSlider: NSSlider?
    @IBOutlet var speakerIcon: NSImageView?
    @IBOutlet var messageLabel: NSTextField?

    @objc func receiveNotification(_ notification: NSNotification) {
        print(#function)
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
    
    func showUI(isMusicAppRunning: Bool) {
        self.playButton?.isHidden = !isMusicAppRunning
        self.nextButton?.isHidden = !isMusicAppRunning
        self.prevButton?.isHidden = !isMusicAppRunning
        self.volumeSlider?.isHidden = !isMusicAppRunning
        self.speakerIcon?.isHidden = !isMusicAppRunning
        self.messageLabel?.isHidden = isMusicAppRunning
    }
    
    func update() {
        Task {
            if let musicApp = SBApplication.musicApp {
                guard let currentVolume = musicApp.soundVolume else { return }
                guard let state = musicApp.playerState else { return }
                DispatchQueue.main.async {
                    if let slider = self.volumeSlider {
                        slider.doubleValue = Double(currentVolume)
                        self.speakerIcon?.updateSoundVolume(with: slider)
                    }
                    switch state {
                    case .playing:
                        self.playButton?.image = NSImage.init(systemSymbolName: "pause.circle", accessibilityDescription: nil)
                    case .paused:
                        self.playButton?.image = NSImage.init(systemSymbolName: "play.circle", accessibilityDescription: nil)
                    default:
                        break
                    }
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let center = DistributedNotificationCenter.default()
        center.addObserver(self, selector: #selector(receiveNotification(_:)), name: NSNotification.Name("com.apple.Music.playerInfo"), object: nil)
    }
    
    @IBAction func didPushPlayButton(sender: NSButton) {
        if let musicApp = SBApplication.musicApp {
            musicApp.playpause?()
        }
    }
    
    @IBAction func didPushForwardButton(sender: NSButton) {
        if let musicApp = SBApplication.musicApp {
            musicApp.nextTrack?()
        }
    }
    
    @IBAction func didPushPrevButton(sender: NSButton) {
        if let musicApp = SBApplication.musicApp {
            musicApp.previousTrack?()
        }
    }
    
    @IBAction func didChangeVolume(sender: NSSlider) {
        if let musicApp = SBApplication.musicApp {
            musicApp.setSoundVolume?(sender.integerValue)
        }
    }
    
    deinit {
        print("\(self.className) is deinited.")
    }
}
