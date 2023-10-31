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
        }
    }
}
