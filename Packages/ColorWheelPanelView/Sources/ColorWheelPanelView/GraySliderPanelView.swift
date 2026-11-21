//
//  GraySliderPanelView.swift
//  ColorWheelPanelView
//
//  Created by Yuichi Yoshida on 2022/04/20.
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

#if os(macOS)

import Cocoa

public protocol GraySliderPanelViewDelegate: AnyObject {
    func didChangeColor(brightness: Double)
}

public class GraySliderPanelView: NSView {
    
    public weak var delegate: GraySliderPanelViewDelegate?
    
    private let brightnessSlider: NSSlider = NSSlider(frame: .zero)
    private let sliderBackgroudView = SliderBackgroundView(frame: .zero)
    
    public var brightness: CGFloat = 0 {
        didSet {
            brightnessSlider.floatValue = 1.0 - Float(brightness)
            if let delegate = delegate {
                delegate.didChangeColor(brightness: brightness)
            }
        }
    }
    
    public var isContinuous = false {
        didSet {
            brightnessSlider.isContinuous = isContinuous
        }
    }
    
    @IBAction private func didBrightnessSliderChange(sender: NSSlider) {
        self.brightness = 1 - CGFloat(sender.floatValue)
    }
        
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        brightnessSlider.cell = BrightnessSliderCell()
        
        brightnessSlider.target = self
        brightnessSlider.action = #selector(self.didBrightnessSliderChange(sender:))
        
        self.addSubview(sliderBackgroudView)
        self.addSubview(brightnessSlider)
        
        brightnessSlider.translatesAutoresizingMaskIntoConstraints = false
        sliderBackgroudView.translatesAutoresizingMaskIntoConstraints = false
        
        self.wantsLayer = true

        self.addConstraints([
            self.centerXAnchor.constraint(equalTo: brightnessSlider.centerXAnchor),
            self.centerXAnchor.constraint(equalTo: sliderBackgroudView.centerXAnchor),
            self.centerYAnchor.constraint(equalTo: brightnessSlider.centerYAnchor),
            brightnessSlider.centerXAnchor.constraint(equalTo: sliderBackgroudView.centerXAnchor),
            brightnessSlider.centerYAnchor.constraint(equalTo: sliderBackgroudView.centerYAnchor),
        ])
        
        // The following parameters read from AppKit.
        let sliderWidth = Double(228)
        let sliderHeight = Double(20)
        let horizontalLeading = Double(8)
        let heightBackground = Double(14)
        
        brightnessSlider.addConstraints([
            brightnessSlider.widthAnchor.constraint(equalToConstant: sliderWidth),
            brightnessSlider.heightAnchor.constraint(equalToConstant: sliderHeight)
        ])
        
        sliderBackgroudView.addConstraints([
            sliderBackgroudView.widthAnchor.constraint(equalToConstant: sliderWidth - horizontalLeading),
            sliderBackgroudView.heightAnchor.constraint(equalToConstant: heightBackground)
        ])

//        self.layer?.backgroundColor = NSColor.red.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
#if MEMORY_DEBUG
    deinit {
        print(Self.Type.self)
        print(#function)
    }
#endif
}

#endif
