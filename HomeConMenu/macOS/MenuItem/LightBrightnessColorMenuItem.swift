//
//  LightBrightnessColorMenuItem.swift
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

import Cocoa
import ColorWheelPanelView
import os

class LightBrightnessColorMenuItem: LightColorMenuItem, GraySliderPanelViewDelegate {
    
    let brightnessCharcteristicIdentifier: UUID
    
    override func UUIDs() -> [UUID] {
        return [brightnessCharcteristicIdentifier]
    }
    
    override func bind(with uniqueIdentifier: UUID) -> Bool {
        return uniqueIdentifier == brightnessCharcteristicIdentifier
    }
    
    override init?(serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        guard let brightnessChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .brightness
        }) else { return nil }
        
        let brightness = brightnessChara.value as? CGFloat ?? CGFloat(100)

        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
        
        super.init(serviceInfo: serviceInfo, mac2ios: mac2ios)
        
        let view = GraySliderPanelView()
        
        if let mac2ios = mac2ios {
            do {
                guard let brightness = try mac2ios.getCharacteristic(of: brightnessCharcteristicIdentifier) as? Double
                else { throw HomeConMenuError.characteristicTypeError(serviceInfo.name, serviceInfo.uniqueIdentifier, brightness.description, brightnessChara.uniqueIdentifier) }
                self.color = NSColor(hue: 1.0, saturation: 0.0, brightness: brightness/100.0, alpha: 1.0)
            } catch let error as HomeConMenuError {
                Logger.app.error("\(error.localizedDescription)")
            } catch {
                Logger.app.error("Can not get brightness from characteristic. - \(error.localizedDescription)")
            }
        }
        
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
        default:
            do {}
        }
    }
    
    func didChangeColor(brightness: Double) {
        let brightness100 = brightness * 100
        mac2ios?.setCharacteristic(of: brightnessCharcteristicIdentifier, object: brightness100)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
