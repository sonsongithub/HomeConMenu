//
//  LightRGBColorMenuItem.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2024/02/15.
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
import Cocoa
import os
import ColorWheelPanelView

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
        case saturationCharcteristicIdentifier:
            updateColor(hue: nil, saturation: value / 100.0, brightness: nil)
        case brightnessCharcteristicIdentifier:
            updateColor(hue: nil, saturation: nil, brightness: value / 100.0)
        default:
            do {}
        }
    }
    
    override init?(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        guard let brightnessChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .brightness
        }) else { return nil }
        guard let hueChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .hue
        }) else { return nil }
        guard let saturationChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .saturation
        }) else { return nil }
        
        self.hueCharcteristicIdentifier = hueChara.uniqueIdentifier
        self.saturationCharcteristicIdentifier = saturationChara.uniqueIdentifier
        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
                
        super.init(serviceInfo: serviceInfo, mac2ios: mac2ios)
        
        let view = ColorWheelPanelView()
        
        if let mac2ios = mac2ios {
            do {
                guard let hue = try mac2ios.getCharacteristic(of: hueCharcteristicIdentifier) as? Double
                else { throw HomeConMenuError.characteristicTypeError }
                guard let saturation = try mac2ios.getCharacteristic(of: saturationCharcteristicIdentifier) as? Double
                else { throw HomeConMenuError.characteristicTypeError }
                guard let brightness = try mac2ios.getCharacteristic(of: brightnessCharcteristicIdentifier) as? Double
                else { throw HomeConMenuError.characteristicTypeError }
                self.color = NSColor(hue: hue/360.0, saturation: saturation/100.0, brightness: brightness/100.0, alpha: 1.0)
                
                view.hue = hue / 360.0
                view.saturation = saturation / 100.0
                view.brightness = brightness / 100.0
            } catch {
                Logger.app.error("Can not get brightness, hue, staturation from characteristic. - \(error.localizedDescription)")
            }
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
        
        mac2ios?.setCharacteristic(of: hueCharcteristicIdentifier, object: hue360)
        mac2ios?.setCharacteristic(of: saturationCharcteristicIdentifier, object: saturation100)
        mac2ios?.setCharacteristic(of: brightnessCharcteristicIdentifier, object: brightness100)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
