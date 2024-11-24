//
//  ShortcutInfo.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2023/09/13.
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
import AppKit

enum ShortcutInfo {
    case lightbulb(name: String, uniqueIdentifier: UUID)
    case outlet(name: String, uniqueIdentifier: UUID)
    case `switch`(name: String, uniqueIdentifier: UUID)
    case home(name: String, uniqueIdentifier: UUID)
    case musicPlay
    case musicForward
    case musicBackward
    
    var name: String {
        switch self {
        case .lightbulb(let name, _):
            return name
        case .outlet(let name, _):
            return name
        case .switch(let name, _):
            return name
        case .home(let name, _):
            return name
        case .musicPlay:
            return NSLocalizedString("Play/Pause", comment: "")
        case .musicForward:
            return NSLocalizedString("Next", comment: "")
        case .musicBackward:
            return NSLocalizedString("Previous", comment: "")
        }
    }
    
    var uniqueIdentifier: UUID {
        switch self {
        case .lightbulb(_, let uniqueIdentifier):
            return uniqueIdentifier
        case .outlet(_, let uniqueIdentifier):
            return uniqueIdentifier
        case .switch(_, let uniqueIdentifier):
            return uniqueIdentifier
        case .home(_, let uniqueIdentifier):
            return uniqueIdentifier
        case .musicPlay:
            return UUID(uuidString: "98119D00-5FB7-46B8-AEF8-BA95D6E98860")!
        case .musicForward:
            return UUID(uuidString: "DA6E43E7-C9F3-4C32-B339-4AA01B4955FB")!
        case .musicBackward:
            return UUID(uuidString: "7AB9D57D-0E22-496A-A9F1-C2BC20747213")!
        }
    }
    
    var image: NSImage {
        switch self {
        case .lightbulb(_, _):
            return NSImage(systemSymbolName: "lightbulb", accessibilityDescription: nil)!
        case .outlet(_, _):
            return NSImage(systemSymbolName: "powerplug", accessibilityDescription: nil)!
        case .switch(_, _):
            return NSImage(systemSymbolName: "switch.2", accessibilityDescription: nil)!
        case .home(_, _):
            return NSImage(systemSymbolName: "house", accessibilityDescription: nil)!
        case .musicPlay:
            return NSImage(systemSymbolName: "play.fill", accessibilityDescription: nil)!
        case .musicForward:
            return NSImage(systemSymbolName: "forward.fill", accessibilityDescription: nil)!
        case .musicBackward:
            return NSImage(systemSymbolName: "backward.fill", accessibilityDescription: nil)!
        }
    }
}
