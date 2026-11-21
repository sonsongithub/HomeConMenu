//
//  SliderBackgroundView.swift
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

internal class SliderBackgroundView: NSView {
    
    var hue: Double = 0 {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }
    var saturation: Double = 0 {
        didSet {
            self.setNeedsDisplay(self.bounds)
        }
    }
    
    override func draw(_ dirtyRect: NSRect) {
        let cornerRadius = Double(4)
        
        // gradient color
        let colorStart = NSColor(calibratedHue: hue, saturation: saturation, brightness: 1, alpha: 1)
        let colorEnd = NSColor(calibratedHue: hue, saturation: saturation, brightness: 0, alpha: 1)
        let gradient = NSGradient(starting: colorStart, ending: colorEnd)
        
        // draw gradient color with clipping
        let rounded = NSBezierPath(roundedRect: self.bounds, xRadius: cornerRadius, yRadius: cornerRadius)
        rounded.setClip()
        gradient?.draw(in: self.bounds, angle: 0)
        
         // draw frame
        NSColor.gray.setStroke()
        let path = NSBezierPath(roundedRect: self.bounds, xRadius: cornerRadius, yRadius: cornerRadius)
        path.lineWidth = 2
        path.stroke()
    }
#if MEMORY_DEBUG
    deinit {
        print(Self.Type.self)
        print(#function)
    }
#endif
}

#endif
