//
//  MusicTrackView.swift
//  HomeConMenu
//
//  Created by sonson on 2024/11/17.
//

import AppKit

class MusicTrackView : NSView {
    
    @IBOutlet var atworkImageView: NSImageView?
    @IBOutlet var titleLabel: NSTextField?
    @IBOutlet var artistLabel: NSTextField?
    @IBOutlet var albumLabel: NSTextField?
    
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.titleLabel?.stringValue = ""
        self.artistLabel?.stringValue = ""
        self.albumLabel?.stringValue = ""
    }
    
    static func create(frame frameRect: NSRect) -> MusicTrackView? {
        var topLevelObjects: NSArray? = nil
        Bundle.main.loadNibNamed("MusicTrackView", owner: self, topLevelObjects: &topLevelObjects)
        guard let view = topLevelObjects?.first(where: { $0 is NSView }) as? MusicTrackView else {
            return nil
        }
        view.frame = frameRect
        view.autoresizingMask = [.width, .height]
        return view
    }
    
    func update() {
        Task {
            guard let musicApp = SBApplication.musicApp else { return }
            guard let currentTrack = musicApp.currentTrack else { return }
            guard let artwork = currentTrack.artworks?().first else { return }
            guard let title = currentTrack.name else { return }
            guard let artist = currentTrack.artist else { return }
            guard let album = currentTrack.album else { return }
            DispatchQueue.main.async {
                self.atworkImageView?.image = artwork.data
                self.titleLabel?.stringValue = String(title)
                self.artistLabel?.stringValue = String(artist)
                self.albumLabel?.stringValue = String(album)
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
    
    deinit {
        print("MusicTrackView deinit")
    }
}
