//
//  MusicPlayerView.swift
//  HomeConMenu
//
//  Created by sonson on 2024/11/16.
//

import AppKit
import KeyboardShortcuts

class MusicPlayerView : NSView {
    
    @IBOutlet var playButton: NSButton?
    @IBOutlet var nextButton: NSButton?
    @IBOutlet var prevButton: NSButton?
    @IBOutlet var volumeSlider: NSSlider?
    @IBOutlet var speakerIcon: NSImageView?
    @IBOutlet var messageLabel: NSTextField?
    
    static func create(frame frameRect: NSRect) -> MusicPlayerView? {
        var topLevelObjects: NSArray? = nil
        Bundle.main.loadNibNamed("MusicPlayerView", owner: self, topLevelObjects: &topLevelObjects)
        guard let view = topLevelObjects?.first(where: { $0 is NSView }) as? MusicPlayerView else {
            return nil
        }
        view.frame = frameRect
        view.autoresizingMask = [.width, .height]
        view.setup()
        return view
    }
    
    @objc func receiveNotification(_ notification: NSNotification) {
        print(#function)
        if let userInfo = notification.userInfo {
            if let message = userInfo["Player State"] as? String {
                if message == "Playing" {
                    self.update()
                    self.playButton?.image = NSImage.init(systemSymbolName: "pause.circle", accessibilityDescription: nil)
                }
                if message == "Paused" {
                    self.update()
                    self.playButton?.image = NSImage.init(systemSymbolName: "play.circle", accessibilityDescription: nil)
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
                DispatchQueue.main.async {
                    if let slider = self.volumeSlider {
                        slider.doubleValue = Double(currentVolume)
                        self.speakerIcon?.updateSoundVolume(with: slider)
                    }
                }
            }
        }
    }
    
    var dummyItem: [NSMenuItem] = []
    
    func setup() {
        let center = DistributedNotificationCenter.default()
        center.addObserver(self, selector: #selector(receiveNotification(_:)), name: NSNotification.Name("com.apple.Music.playerInfo"), object: nil)
        
        [ShortcutInfo.musicPlay, ShortcutInfo.musicForward, ShortcutInfo.musicBackward].forEach { info in
            if let r = KeyboardShortcuts.Name(rawValue: info.uniqueIdentifier.uuidString) {
                let dummy = NSMenuItem()
                dummy.setShortcut(for: r)
                self.dummyItem.append(dummy)
                KeyboardShortcuts.onKeyDown(for: r, action: {
                    self.shortcut(info: info)
                })
            }
        }
    }
    
    func shortcut(info: ShortcutInfo) {
        switch info {
        case .musicPlay:
            if let musicApp = SBApplication.musicApp {
                musicApp.playpause?()
            }
        case .musicForward:
            if let musicApp = SBApplication.musicApp {
                musicApp.nextTrack?()
            }
        case .musicBackward:
            if let musicApp = SBApplication.musicApp {
                musicApp.previousTrack?()
            }
        default:
            break
        }
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
        self.speakerIcon?.updateSoundVolume(with: sender)
    }
    
    deinit {
        print("\(self.className) is deinited.")
    }
}
