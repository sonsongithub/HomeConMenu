//
//  LightbulbMenuItem.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/04/16.
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
import KeyboardShortcuts

class LightbulbMenuItem: ToggleMenuItem {
    
    let subColorMenu = NSMenu()
    
    override var reachable: Bool {
        didSet {
            if reachable {
                if subColorMenu.items.count > 0 {
                    self.submenu = subColorMenu
                    if let item = subColorMenu.items.first as? LightColorMenuItem {
                        self.image = item.createImage()
                    }
                } else {
                    self.image = icon
                }
            } else {
                self.image = NSImage(systemSymbolName: "exclamationmark.triangle", accessibilityDescription: nil)
                self.submenu = nil
            }
        }
    }

    override var icon: NSImage? {
        return NSImage(systemSymbolName: "lightbulb", accessibilityDescription: nil)
    }
    
    override init?(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        
        super.init(serviceInfo: serviceInfo, mac2ios: mac2ios)
        
        self.image = NSImage(systemSymbolName: "lightbulb", accessibilityDescription: nil)
        self.action = #selector(self.toggle(sender:))
        self.target = self
        
        if let r = KeyboardShortcuts.Name(rawValue: serviceInfo.uniqueIdentifier.uuidString) {
            self.setShortcut(for: r)
            KeyboardShortcuts.onKeyDown(for: r, action: {
                self.toggle(sender: self)
            })
        }
        
        if let lightColorMenuItem = LightColorMenuItem.item(serviceInfo: serviceInfo, mac2ios: mac2ios) as? LightColorMenuItem {
            subColorMenu.addItem(lightColorMenuItem)
            self.submenu = subColorMenu
            self.image = lightColorMenuItem.createImage()
        }
    }
    
    override init?(serviceGroupInfo: ServiceGroupInfoProtocol, mac2ios: mac2iOS?) {
        super.init(serviceGroupInfo: serviceGroupInfo, mac2ios: mac2ios)
        reachable = true
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
