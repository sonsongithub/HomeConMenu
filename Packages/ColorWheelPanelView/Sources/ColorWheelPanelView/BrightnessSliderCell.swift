//
//  BrightnessSliderCell.swift
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

internal class BrightnessSliderCell: NSSliderCell {
    
    override func drawKnob(_ knobRect: NSRect) {
        let bounds = controlView?.bounds ?? knobRect
        let lineWidth: CGFloat = 1

        // Both panels center a 14-point gradient in a 20-point slider.
        // Keep the custom thumb inside that track (8 x 12 points at this size),
        // rather than subtracting fixed offsets from AppKit's changing knob size.
        let preferredHeight = bounds.height * 0.6
        let height = max(0, min(preferredHeight, knobRect.height - lineWidth,
                                (knobRect.width - lineWidth) * 1.5))
        guard height > 0 else { return }
        let width = height * 2 / 3
        let rect = NSRect(
            x: knobRect.midX - width / 2,
            y: bounds.midY - height / 2,
            width: width,
            height: height
        )
        let path = NSBezierPath(roundedRect: rect, xRadius: width / 2, yRadius: width / 2)
        NSColor.white.setFill()
        path.fill()
        path.lineWidth = lineWidth
        NSColor.lightGray.setStroke()
        path.stroke()
    }

    override func drawBar(inside rect: NSRect, flipped: Bool) {
        // nothing to be drawn
    }
#if MEMORY_DEBUG
    deinit {
        print(Self.Type.self)
        print(#function)
    }
#endif
}

#endif
