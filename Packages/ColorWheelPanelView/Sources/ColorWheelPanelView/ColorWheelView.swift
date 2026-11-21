//
//  ColorWheelView.swift
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

internal protocol ColorWheelViewDelegate: AnyObject {
    var hue: Double { set get}
    var saturation: Double { set get}
    var brightness: Double { set get}
    func callDelegate()
}

internal class ColorWheelView: NSView {
    weak var delegate: ColorWheelViewDelegate?
    
    let wheelLayer = CALayer()
    let borderLayer = CAShapeLayer()
    
    // property
    var isContinuous = false
    let scope = NSImageView(image: NSImage(systemSymbolName: "scope", accessibilityDescription: nil)!)
    let scale: CGFloat = NSScreen.main?.backingScaleFactor ?? 1
    
    func updateContents(hue: Double, saturation: Double, brightness: Double) {
        // re-draw color wheel
        if wheelLayer.frame.size.width > 0 {
            wheelLayer.contents = createColorWheel(wheelLayer.frame.size, brightness: brightness)
        }
        
        // update the location of the scope
        let radius = wheelLayer.frame.width / 2
        let x = cos(hue * Double.pi * 2) * saturation * radius + radius
        let y = sin(hue * Double.pi * 2) * saturation * radius + radius
        var rect = self.scope.frame
        rect.origin = CGPoint(x: x - rect.size.width/2, y: y - rect.size.height/2)
        self.scope.frame = rect
    }
    
    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        
        self.wantsLayer = true
        self.allowedTouchTypes = .direct
        
        self.layer?.addSublayer(wheelLayer)
        self.layer?.addSublayer(borderLayer)
        self.addSubview(scope)
    }
    
    override func layout() {
        super.layout()
        borderLayer.path = NSBezierPath(ovalIn: CGRect(x: 1, y: 1, width: self.frame.width-2, height: self.frame.height-2)).cgPath
        borderLayer.fillColor = CGColor.clear
        borderLayer.strokeColor = CGColor.init(gray: 0.4, alpha: 1.0)
        borderLayer.lineWidth = 1
        wheelLayer.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
    }
    
    override var acceptsFirstResponder: Bool {
        return true
    }
    
    func getIndicatorCoordinate(_ coord: CGPoint) -> (point: CGPoint, isCenter: Bool) {
        // Making sure that the indicator can't get outside the Hue and Saturation wheel
        
        let dimension: CGFloat = min(wheelLayer.frame.width, wheelLayer.frame.height)
        let radius: CGFloat = dimension/2
        let wheelLayerCenter: CGPoint = CGPoint(x: wheelLayer.frame.origin.x + radius, y: wheelLayer.frame.origin.y + radius)

        let dx: CGFloat = coord.x - wheelLayerCenter.x
        let dy: CGFloat = coord.y - wheelLayerCenter.y
        let distance: CGFloat = sqrt(dx*dx + dy*dy)
        var outputCoord: CGPoint = coord
        
        // If the touch coordinate is outside the radius of the wheel, transform it to the edge of the wheel with polar coordinates
        if (distance > radius) {
            let theta: CGFloat = atan2(dy, dx)
            outputCoord.x = radius * cos(theta) + wheelLayerCenter.x
            outputCoord.y = radius * sin(theta) + wheelLayerCenter.y
        }
        
        // If the touch coordinate is close to center, focus it to the very center at set the color to white
        let whiteThreshold: CGFloat = 2
        var isCenter = false
        if (distance < whiteThreshold) {
            outputCoord.x = wheelLayerCenter.x
            outputCoord.y = wheelLayerCenter.y
            isCenter = true
        }
        return (outputCoord, isCenter)
    }
    
    private func update(event: NSEvent, isContinuous: Bool = false) {
        let point = self.convert(event.locationInWindow, from: event.window?.contentView)
        let indicator = getIndicatorCoordinate(point)
        let point2 = indicator.point
        var color = (hue: CGFloat(0), saturation: CGFloat(0))
        if !indicator.isCenter  {
            color = hueSaturationAtPoint(CGPoint(x: point2.x*scale, y: point2.y*scale))
        }
        
        delegate?.hue = color.hue
        delegate?.saturation = color.saturation
            
        if isContinuous {
            delegate?.callDelegate()
        }
    }
    
    override func mouseDragged(with event: NSEvent) {
        update(event: event, isContinuous: isContinuous)
    }
    
    override func mouseUp(with event: NSEvent) {
        update(event: event, isContinuous: true)
    }
    
    override func mouseDown(with event: NSEvent) {
        update(event: event, isContinuous: isContinuous)
    }
    
    private func createColorWheel(_ size: CGSize, brightness: Double) -> CGImage {

        // Creates a bitmap of the Hue Saturation wheel
        let originalWidth: CGFloat = size.width
        let originalHeight: CGFloat = size.height
        let dimension: CGFloat = min(originalWidth*scale, originalHeight*scale)
        let bufferLength: Int = Int(dimension * dimension * 4)
        
        let bitmapData: CFMutableData = CFDataCreateMutable(nil, 0)
        CFDataSetLength(bitmapData, CFIndex(bufferLength))
        let bitmap = CFDataGetMutableBytePtr(bitmapData)
        
        for y in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {
            for x in stride(from: CGFloat(0), to: dimension, by: CGFloat(1)) {
                var hsv: HSV = (hue: 0, saturation: 0, brightness: 0, alpha: 0)
                var rgb: RGB = (red: 0, green: 0, blue: 0, alpha: 0)
                
                let color = hueSaturationAtPoint(CGPoint(x: x, y: y))
                let hue = color.hue
                let saturation = color.saturation
                var a: CGFloat = 0.0
                if (saturation < 1.0) {
                    // Antialias the edge of the circle.
                    if (saturation > 0.99) {
                        a = (1.0 - saturation) * 100
                    } else {
                        a = 1.0;
                    }
                    
                    hsv.hue = hue
                    hsv.saturation = saturation
                    hsv.brightness = brightness
                    hsv.alpha = a
                    rgb = hsv2rgb(hsv)
                }
                let offset = Int(4 * (x + (dimension - y - 1) * dimension))
                bitmap?[offset] = UInt8(rgb.red*255)
                bitmap?[offset + 1] = UInt8(rgb.green*255)
                bitmap?[offset + 2] = UInt8(rgb.blue*255)
                bitmap?[offset + 3] = UInt8(rgb.alpha*255)
            }
        }
        
        // Convert the bitmap to a CGImage
        let colorSpace: CGColorSpace? = CGColorSpaceCreateDeviceRGB()
        let dataProvider: CGDataProvider? = CGDataProvider(data: bitmapData)
        let bitmapInfo = CGBitmapInfo(rawValue: CGBitmapInfo().rawValue | CGImageAlphaInfo.last.rawValue)
        let imageRef: CGImage? = CGImage(width: Int(dimension), height: Int(dimension), bitsPerComponent: 8, bitsPerPixel: 32, bytesPerRow: Int(dimension) * 4, space: colorSpace!, bitmapInfo: bitmapInfo, provider: dataProvider!, decode: nil, shouldInterpolate: false, intent: CGColorRenderingIntent.defaultIntent)
        return imageRef!
    }
    
    private func hueSaturationAtPoint(_ position: CGPoint) -> (hue: CGFloat, saturation: CGFloat) {

        let c = wheelLayer.frame.width * scale / 2
        let dx = CGFloat(position.x - c) / c
        let dy = CGFloat(position.y - c) / c
        let d = sqrt(CGFloat (dx * dx + dy * dy))
        
        let saturation: CGFloat = d
        
        var hue: CGFloat
        if (d == 0) {
            hue = 0;
        } else {
            hue = atan2(dy, dx) / Double.pi / 2.0
            if hue < 0 {
                hue = hue + 1.0
            }
        }
        return (hue, saturation)
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
