//
//  Music+extension.swift
//  MusicConMenu
//
//  Created by Yuichi Yoshida on 2024/11/05.
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


import Foundation

struct AirPlayDeviceInfo : Hashable {
    let name: String
    let kind: MusicEAPD
    
    func hash(into hasher: inout Hasher) {
        (self.name + self.kind.description).hash(into: &hasher)
    }
}

extension SBApplication {
    static var musicApp: MusicApplication? {
        guard NSWorkspace.shared.runningApplications.contains(where: { $0.bundleIdentifier == "com.apple.Music" }) else { return nil }
        return SBApplication(bundleIdentifier: "com.apple.Music")
    }
    
    static func getCurrentPlaylistNames() -> [String] {
        var playlists: [String] = []
        if let musicApp = SBApplication.musicApp {
            musicApp.playlists?().forEach { playlist in
                if let name = playlist.name {
                    playlists.append(String(name))
                }
            }
        }
        return playlists
    }
    
    static func getCurrentAirPlayDevices() -> [AirPlayDeviceInfo] {
        var devices: [AirPlayDeviceInfo] = []
        if let musicApp = SBApplication.musicApp {
            musicApp.AirPlayDevices?().forEach { device in
                if let name = device.name, let kind = device.kind {
                    devices.append(AirPlayDeviceInfo(name: String(name), kind: kind))
                }
            }
        }
        return devices
    }
    
    static func isRunning () -> Bool {
        do {
            let script = """
            set appName to "Music"
            tell application "System Events"
                set appRunning to (name of processes) contains appName
            end tell
            return appRunning
            """
            let result: Int = try AppleScriptManager.execute(script: script)
            return result == 1
        } catch {
            print(error)
            return false
        }
    }
}

extension MusicPlaylist {
    func play() {
        do {
            guard let name = self.name else { return }
            let script = """
            tell application "Music"
                play the playlist named "\(name)"
            end tell
            """
            _ = try AppleScriptManager.call(script: script)
        } catch {
            print(error)
        }
    }
}

extension MusicEAPD {
    
    var description: String {
        switch self {
        case .computer:
            return "Computer"
        case .airPortExpress:
            return "AirPort Express"
        case .appleTV:
            return "Apple TV"
        case .airPlayDevice:
            return "AirPlay Device"
        case .bluetoothDevice:
            return "Bluetooth Device"
        case .homePod:
            return "HomePod"
        case .tV:
            return "TV"
        case .unknown:
            return "Unknown"
        }
    }
    
    var icon: NSImage {
        switch self {
        case .computer:
            return NSImage.init(systemSymbolName: "desktopcomputer", accessibilityDescription: nil)!
        case .airPortExpress:
            return NSImage.init(systemSymbolName: "airport.extreme", accessibilityDescription: nil)!
        case .appleTV:
            return NSImage.init(systemSymbolName: "appletv", accessibilityDescription: nil)!
        case .airPlayDevice:
            return NSImage.init(systemSymbolName: "airplayaudio", accessibilityDescription: nil)!
        case .bluetoothDevice:
            return NSImage.init(systemSymbolName: "airplayaudio", accessibilityDescription: nil)!
        case .homePod:
            return NSImage.init(systemSymbolName: "homepod.fill", accessibilityDescription: nil)!
        case .tV:
            return NSImage.init(systemSymbolName: "appletv.fill", accessibilityDescription: nil)!
        case .unknown:
            return NSImage.init(systemSymbolName: "hifispeaker.fill", accessibilityDescription: nil)!
        }
    }
}
