//
//  LightColorMenu.swift
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

class LightColorMenuItem: NSMenuItem, NSWindowDelegate, MenuItemFromUUID {
    var color = NSColor.white
    var mac2ios: mac2iOS?
    
    var colorPanel: CustomColorPanel?
    let accessoryName: String
    
    func UUIDs() -> [UUID] {
        return []
    }
    
    func bind(with uniqueIdentifier: UUID) -> Bool {
        return false
    }
    
    func createImage() -> NSImage? {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 14, height: 14))
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer?.backgroundColor = color.cgColor
        view.layer?.cornerRadius = 2
        
        let destinationSize = Double(14)
        
        let image = NSImage(size: NSSize(width: destinationSize, height: destinationSize))
        
        guard let icon = NSImage(systemSymbolName: "lightbulb.fill", accessibilityDescription: nil) else { return nil }
        guard let frameIcon = NSImage(systemSymbolName: "lightbulb", accessibilityDescription: nil) else { return nil }
        
        var width = Double(1)
        var height = Double(1)
        if icon.size.width > icon.size.height {
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
        
        icon.draw(in: destination, from: source, operation: .destinationIn, fraction: 1)
        frameIcon.draw(in: destination, from: source, operation: .darken, fraction: 1)
        image.unlockFocus()

        return image
    }
    
    init?(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        self.mac2ios = mac2ios
        self.accessoryName = accessoryInfo.name ?? "unknown"
        super.init(title: "", action: nil, keyEquivalent: "")
    }
    
    func update(hueFromHMKit: CGFloat?, saturationFromHMKit: CGFloat?, brightnessFromHMKit: CGFloat?) {
        let hue = (hueFromHMKit != nil) ?  hueFromHMKit! / 360.0 : self.color.hueComponent
        let saturation = (saturationFromHMKit != nil) ?  saturationFromHMKit! / 100.0 : self.color.saturationComponent
        let brightness = (brightnessFromHMKit != nil) ?  brightnessFromHMKit! / 100.0 : self.color.brightnessComponent
        
        if let parent = self.parent {
            self.color = NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
            parent.image = createImage()
        }
    }
    
    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.accessoryName = "unknown"
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func item(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) -> NSMenuItem? {
        
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
            return LightRGBColorMenuItem(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)
        } else if brightnessChara != nil {
            return LightBrightnessColorMenuItem(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)
        }
        
        return nil
    }
}

class LightBrightnessColorMenuItem: LightColorMenuItem, GraySliderPanelViewDelegate {
    
    let brightnessCharcteristicIdentifier: UUID
    
    override func UUIDs() -> [UUID] {
        return [brightnessCharcteristicIdentifier]
    }
    
    override func bind(with uniqueIdentifier: UUID) -> Bool {
        return uniqueIdentifier == brightnessCharcteristicIdentifier
    }
    
    override init?(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        guard let brightnessChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .brightness
        }) else { return nil }
        
        let brightness = brightnessChara.value as? CGFloat ?? CGFloat(100)

        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
        
        super.init(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)
        
        let view = GraySliderPanelView()
        view.frame = NSRect(x: 0, y: 0, width: 250, height: 50)
        view.brightness = brightness / 100
        self.view = view
        view.isContinuous = false
        view.delegate = self
    }
    
    func didChangeColor(brightness: Double) {
        let brightness100 = brightness * 100
        mac2ios?.updateColor(uniqueIdentifier: brightnessCharcteristicIdentifier, value: brightness100)
        self.update(hueFromHMKit: 0, saturationFromHMKit: 0, brightnessFromHMKit: brightness100)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LightRGBColorMenuItem: LightColorMenuItem, ColorWheelPanelViewDelegate {
    
    let hueCharcteristicIdentifier: UUID
    let saturationCharcteristicIdentifier: UUID
    let brightnessCharcteristicIdentifier: UUID
    
    override func UUIDs() -> [UUID] {
        return [hueCharcteristicIdentifier, saturationCharcteristicIdentifier, brightnessCharcteristicIdentifier]
    }
    
    override func bind(with uniqueIdentifier: UUID) -> Bool {
        return uniqueIdentifier == hueCharcteristicIdentifier || uniqueIdentifier == saturationCharcteristicIdentifier || uniqueIdentifier == brightnessCharcteristicIdentifier
    }
    
    override init?(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        guard let brightnessChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .brightness
        }) else { return nil }
        guard let hueChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .hue
        }) else { return nil }
        guard let saturationChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .saturation
        }) else { return nil }
        
        let hue = hueChara.value as? CGFloat ?? CGFloat(0)
        let saturation = saturationChara.value as? CGFloat ?? CGFloat(1)
        let brightness = brightnessChara.value as? CGFloat ?? CGFloat(1)

        self.hueCharcteristicIdentifier = hueChara.uniqueIdentifier
        self.saturationCharcteristicIdentifier = saturationChara.uniqueIdentifier
        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
        
        super.init(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)
        
        let view = ColorWheelPanelView()
        view.isContinuous = false
        view.delegate = self
        view.frame = NSRect(x: 0, y: 0, width: 250, height: 220)
        view.hue = hue / 360.0
        view.saturation = saturation / 100.0
        view.brightness = brightness / 100.0
        self.view = view
    }
    
    func didChangeColor(hue: Double, saturation: Double, brightness: Double) {
        let hue360 = hue * 360.0
        let saturation100 = saturation * 100
        let brightness100 = brightness * 100
        
        mac2ios?.updateColor(uniqueIdentifier: hueCharcteristicIdentifier, value: hue360)
        mac2ios?.updateColor(uniqueIdentifier: saturationCharcteristicIdentifier, value: saturation100)
        mac2ios?.updateColor(uniqueIdentifier: brightnessCharcteristicIdentifier, value: brightness100)
        
        self.update(hueFromHMKit: hue360, saturationFromHMKit: saturation100, brightnessFromHMKit: brightness100)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}