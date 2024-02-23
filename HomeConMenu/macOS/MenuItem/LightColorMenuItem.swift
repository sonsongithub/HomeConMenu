//
//  LightColorMenuItem.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/20.
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
import ColorWheelPanelView
import os

class LightColorMenuItem: NSMenuItem, NSWindowDelegate, MenuItemFromUUID, MenuItemOrder, ErrorMenuItem {
    
    var color = NSColor.white
    var mac2ios: mac2iOS?
    
    // MARK: - MenuItemProtocol

    var reachable: Bool = true
    
    var orderPriority: Int {
        100
    }
    
    func UUIDs() -> [UUID] {
        return []
    }
    
    func bind(with uniqueIdentifier: UUID) -> Bool {
        return false
    }
    
    func updateColor(hue: Double?, saturation: Double?, brightness: Double?) {
        let hue = hue ?? self.color.hueComponent
        let saturation = saturation ?? self.color.saturationComponent
        let brightness = brightness ?? self.color.brightnessComponent
        
        self.color = NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        if let parent = self.parent {
            parent.image = createImage()
        }
    }
    
    func createImage() -> NSImage? {
        let size = CGFloat(16)
        let view = NSView(frame: NSRect(x: 0, y: 0, width: size, height: size))
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer?.backgroundColor = NSColor.clear.cgColor
        
        let destinationSize = Double(size)
        
        let image = NSImage(size: NSSize(width: destinationSize, height: destinationSize))
        
        guard let icon = NSImage(systemSymbolName: "lightbulb.fill", accessibilityDescription: nil) else { return nil }
        guard let frameIcon = NSImage(systemSymbolName: "lightbulb", accessibilityDescription: nil) else { return nil }
        
        var width = Double(1)
        var height = Double(1)
        
        if icon.size.width < icon.size.height {
            width = destinationSize * (icon.size.width / icon.size.height)
            height = destinationSize
        } else {
            width = destinationSize
            height = destinationSize * (icon.size.height / icon.size.width)
        }
        
        let x = (destinationSize - width) / 2
        let y = (destinationSize - height) / 2
        
        image.lockFocus()
        guard let ctx = NSGraphicsContext.current?.cgContext else { return nil }
        
        view.layer?.render(in: ctx)
        let source = NSRect(origin: CGPoint.zero, size: icon.size)
        
        let destination = NSRect(x: x, y: y, width: width, height: height)
        
        
        ctx.setFillColor(NSColor.blue.cgColor)
        let rect = CGRect(x: x+1, y: y, width: width-2, height: height)
        rect.fill()
        
        icon.draw(in: destination, from: source, operation: .destinationIn, fraction: 1)
        frameIcon.draw(in: destination, from: source, operation: .darken, fraction: 1)
        image.unlockFocus()
        
        return image
    }
    
    init?(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        self.mac2ios = mac2ios
        super.init(title: "", action: nil, keyEquivalent: "")
    }
    
    func update(of uniqueIdentifier: UUID, value: Double) {
        // dummy
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    /// Create a sub menu for lightbulb. If `serviceInfo` has characteristics to adjust hue, brightness and staturation, this function returns LightRGBColorMenuItem instance.
    /// If `serviceInfo` has only brightness, returns LightBrightnessColorMenuItem instance. In the other cases, returns nil.
    /// - Parameters:
    ///     - serviceInfo: Service information of the lightbulb.
    ///     - mac2ios: Delegate object to send messages to MacCatalyst from macOS bundle.
    static func createSubMenu(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) -> NSMenuItem? {
        
        let brightnessChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .brightness
        })
        let hueChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .hue
        })
        let saturationChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .saturation
        })
        
        if brightnessChara != nil && hueChara != nil && saturationChara != nil {
            return LightRGBColorMenuItem(serviceInfo: serviceInfo, mac2ios: mac2ios)
        } else if brightnessChara != nil {
            return LightBrightnessColorMenuItem(serviceInfo: serviceInfo, mac2ios: mac2ios)
        }
        
        return nil
    }
}
