//
//  LightColorMenu.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/11/20.
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

class LightColorMenuItem: NSMenuItem, MenuItemFromUUID {//}, NSWindowDelegate, MenuItemFromUUID, MenuItemOrder, ErrorMenuItem {

    var reachable: Bool = true
    
    var orderPriority: Int {
        100
    }
    
    var color = NSColor.white.usingColorSpace(.sRGB)!
    
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
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 14, height: 16))
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
        
        let destination = NSRect(x: x, y: y, width: width, height: height-2)
        
        icon.draw(in: destination, from: source, operation: .destinationIn, fraction: 1)
        frameIcon.draw(in: destination, from: source, operation: .darken, fraction: 1)
        image.unlockFocus()

        return image
    }
    
    init?(service: HCService) {
//        self.mac2ios = mac2ios
        super.init(title: "", action: nil, keyEquivalent: "")
    }
    
    func update(of uniqueIdentifier: UUID, value: Double) {
        // dummy
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    static func item(service: HCService) -> NSMenuItem? {
        
        let brightnessChara = service.characteristics.first(where: { obj in
            obj.type == .brightness
        })
        let hueChara = service.characteristics.first(where: { obj in
            obj.type == .hue
        })
        let saturationChara = service.characteristics.first(where: { obj in
            obj.type == .saturation
        })
        
        if brightnessChara != nil && hueChara != nil && saturationChara != nil {
            return LightRGBColorMenuItem(service: service)
        } else if brightnessChara != nil {
            return LightBrightnessColorMenuItem(service: service)
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
    
    override init?(service: HCService) {
        guard let brightnessChara = service.characteristics.first(where: { obj in
            obj.type == .brightness
        }) else { return nil }
        
        var brightness = CGFloat(0)
        
        if let tmp = brightnessChara.doubleValue {
            brightness = CGFloat(tmp)
        } else {
            brightness = CGFloat(100)
        }

        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
        
        super.init(service: service)
        
        let view = GraySliderPanelView()
        
//        if let mac2ios = mac2ios {
//            do {
//                guard let brightness = try mac2ios.getCharacteristic(of: brightnessCharcteristicIdentifier) as? Double else { throw HomeConMenuError.characteristicTypeError }
//                self.color = NSColor(hue: 1.0, saturation: 0.0, brightness: brightness/100.0, alpha: 1.0)
//            } catch {
//                Logger.app.error("\(error.localizedDescription)")
//            }
//        }
        
        view.frame = NSRect(x: 0, y: 0, width: 250, height: 50)
        view.brightness = brightness / 100
        self.view = view
        view.isContinuous = false
        view.delegate = self
    }
    
    override func update(of uniqueIdentifier: UUID, value: Double) {
        switch uniqueIdentifier {
        case brightnessCharcteristicIdentifier:
            updateColor(hue: nil, saturation: nil, brightness: value / 100.0)
            if let graySlider = self.view as? GraySliderPanelView {
                graySlider.brightness = value / 100.0
            }
        default:
            do {}
        }
    }
    
    func didChangeColor(brightness: Double) {
        updateColor(hue: nil, saturation: nil, brightness: brightness)
        do {
            let characteristic = HCCharacteristic(uuid: brightnessCharcteristicIdentifier)
            characteristic.doubleValue = brightness * 100
            let encoder = JSONEncoder()
            let data = try encoder.encode(characteristic)
            guard let jsonString = String(data: data, encoding: .utf8) else {
                throw NSError(domain: "", code: 0)
            }
            DistributedNotificationCenter.default().postNotificationName(.to_iosNotification, object: jsonString, deliverImmediately: true)
        } catch {
            print(error)
        }
//        let brightness100 = brightness * 100
//        mac2ios?.setCharacteristic(of: brightnessCharcteristicIdentifier, object: brightness100)
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
    
    override func update(of uniqueIdentifier: UUID, value: Double) {
        switch uniqueIdentifier {
        case hueCharcteristicIdentifier:
            updateColor(hue: value / 360.0, saturation: nil, brightness: nil)
            if let colorPanel = self.view as? ColorWheelPanelView {
                colorPanel.hue = value / 360.0
            }
        case saturationCharcteristicIdentifier:
            updateColor(hue: nil, saturation: value / 100.0, brightness: nil)
            if let colorPanel = self.view as? ColorWheelPanelView {
                colorPanel.saturation = value / 100.0
            }
        case brightnessCharcteristicIdentifier:
            updateColor(hue: nil, saturation: nil, brightness: value / 100.0)
            if let colorPanel = self.view as? ColorWheelPanelView {
                colorPanel.brightness = value / 100.0
            }
        default:
            do {}
        }
        if let parent = self.parent {
            parent.image = createImage()
        }
    }
    
    override init?(service: HCService) {
        guard let brightnessChara = service.characteristics.first(where: { obj in
            obj.type == .brightness
        }) else { return nil }
        guard let hueChara = service.characteristics.first(where: { obj in
            obj.type == .hue
        }) else { return nil }
        guard let saturationChara = service.characteristics.first(where: { obj in
            obj.type == .saturation
        }) else { return nil }
        
        self.hueCharcteristicIdentifier = hueChara.uniqueIdentifier
        self.saturationCharcteristicIdentifier = saturationChara.uniqueIdentifier
        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
                
        super.init(service: service)
        
        let view = ColorWheelPanelView()
        
        do {
            guard let hue = hueChara.doubleValue
            else { throw HomeConMenuError.characteristicTypeError }
            guard let saturation = saturationChara.doubleValue
            else { throw HomeConMenuError.characteristicTypeError }
            guard let brightness = brightnessChara.doubleValue
            else { throw HomeConMenuError.characteristicTypeError }
            self.color = NSColor(hue: hue/360.0, saturation: saturation/100.0, brightness: brightness/100.0, alpha: 1.0)
            
            view.hue = hue / 360.0
            view.saturation = saturation / 100.0
            view.brightness = brightness / 100.0
        } catch {
            Logger.app.error("\(error.localizedDescription)")
        }
        
        view.isContinuous = false
        view.delegate = self
        view.frame = NSRect(x: 0, y: 0, width: 250, height: 220)
        self.view = view
    }
    
    func didChangeColor(hue: Double, saturation: Double, brightness: Double) {
        let hue360 = hue * 360.0
        let saturation100 = saturation * 100
        let brightness100 = brightness * 100
        
        let data_array: [(UUID, Double)] = [(hueCharcteristicIdentifier, hue360), (saturationCharcteristicIdentifier, saturation100), (brightnessCharcteristicIdentifier, brightness100)]
        
        updateColor(hue: hue, saturation: saturation, brightness: brightness)
        
        do {
            try data_array.forEach { (uuid, value) in
                let characteristic = HCCharacteristic(uuid: uuid)
                characteristic.doubleValue = value
                let encoder = JSONEncoder()
                let data = try encoder.encode(characteristic)
                guard let jsonString = String(data: data, encoding: .utf8) else {
                    throw NSError(domain: "", code: 0)
                }
                DistributedNotificationCenter.default().postNotificationName(.to_iosNotification, object: jsonString, deliverImmediately: true)
            }
        } catch {
            print(error)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
