//
//  LightColorMenu.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/20.
//

import Cocoa

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
    
    deinit {
        print("LightColorMenu deinit")
//        self.colorPanel?.performClose(self)
    }
    
    @objc func colorDidChange(sender: NSColorPanel) {
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        self.colorPanel = nil
        return true
    }
    
    func openColorPanel() -> CustomColorPanel {
        if let colorPanel = self.colorPanel {
            self.colorPanel = nil
            colorPanel.performClose(nil)
        }
        let cp = CustomColorPanel()
        cp.delegate = self
        return cp
    }
    
    @IBAction func changeColor(sender: NSMenuItem) {
        self.colorPanel = openColorPanel()
        
//        cp.hueCharcteristicIdentifier = lightColorMenu.hueCharcteristicIdentifier
//        cp.saturationCharcteristicIdentifier = lightColorMenu.saturationCharcteristicIdentifier
//        cp.brightnessCharcteristicIdentifier = lightColorMenu.brightnessCharcteristicIdentifier
//        
        self.colorPanel?.title = self.accessoryName
        self.colorPanel?.color = self.color
        
        self.colorPanel?.setTarget(self)
        self.colorPanel?.setAction(#selector(self.colorDidChange(sender:)))
        self.colorPanel?.isContinuous = false
        self.colorPanel?.makeKeyAndOrderFront(self)
    
        if let app = NSWorkspace.shared.runningApplications.filter({ app in
            return app.bundleIdentifier == "com.sonson.HomeConMenu.macOS"
        }).first {
            app.activate(options: .activateIgnoringOtherApps)
        }
    }
    
    func createImage() -> NSImage? {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 14, height: 14))
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer?.backgroundColor = color.cgColor
        view.layer?.cornerRadius = 2
        
        let image = NSImage(size: NSSize(width: 14, height: 14))
        image.lockFocus()
        if let ctx = NSGraphicsContext.current?.cgContext {
            view.layer?.render(in: ctx)
            image.unlockFocus()
        } else {
            return nil
        }
        
        return image
    }
    
    init?(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
//        guard let brightnessChara = serviceInfo.characteristics.first(where: { obj in
//            obj.type == .brightness
//        }) else { return nil }
//
//        guard let hueChara = serviceInfo.characteristics.first(where: { obj in
//            obj.type == .hue
//        }) else { return nil }
//        guard let saturationChara = serviceInfo.characteristics.first(where: { obj in
//            obj.type == .saturation
//        }) else { return nil }
//
//        guard let hue = hueChara.value as? CGFloat,
//              let saturation = saturationChara.value as? CGFloat,
//              let brightness = brightnessChara.value as? CGFloat else { return nil }
        
        self.mac2ios = mac2ios
        self.accessoryName = accessoryInfo.name ?? ""
//        self.hueCharcteristicIdentifier = hueChara.uniqueIdentifier
//        self.saturationCharcteristicIdentifier = saturationChara.uniqueIdentifier
//        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
//        self.color = NSColor(hue: hue / 360.0, saturation: saturation / 100.0, brightness: brightness / 100.0, alpha: 1.0)
        super.init(title: "Change color", action: nil, keyEquivalent: "")
    }
    
    func update(hueFromHMKit: CGFloat?, saturationFromHMKit: CGFloat?, brightnessFromHMKit: CGFloat?) {
        let hue = (hueFromHMKit != nil) ?  hueFromHMKit! / 360.0 : self.color.hueComponent
        let saturation = (saturationFromHMKit != nil) ?  saturationFromHMKit! / 100.0 : self.color.saturationComponent
        let brightness = (brightnessFromHMKit != nil) ?  brightnessFromHMKit! / 100.0 : self.color.brightnessComponent
        
        self.color = NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
        self.image = createImage()
    }
    
    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.accessoryName = ""
//        self.hueCharcteristicIdentifier = UUID()
//        self.saturationCharcteristicIdentifier = UUID()
//        self.brightnessCharcteristicIdentifier = UUID()
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

class LightBrightnessColorMenuItem: LightColorMenuItem {
    let brightnessCharcteristicIdentifier: UUID
    
    var cp: NSColorPanel?
    
    override init?(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        guard let brightnessChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .brightness
        }) else { return nil }
        
        guard let brightness = brightnessChara.value as? CGFloat else { return nil }

        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
        
        super.init(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)
        
        let cp = NSColorPanel()
        self.cp = cp
        self.cp?.mode = .wheel
        self.view = cp.contentView
        
//        let slider = NSSlider(frame: NSRect(x: 0, y: 0, width: 120, height: 33))
//
//        self.view = slider
        
//        self.color = NSColor(hue: 1.0, saturation: 1.0, brightness: brightness / 100.0, alpha: 1.0)
//        self.action = #selector(self.changeColor(sender:))
        self.image = createImage()
        self.target = self
    }
    
    @objc override func colorDidChange(sender: NSColorPanel) {
        guard let panel = sender as? CustomColorPanel else { return }
//        sender
        let brightness = panel.color.brightnessComponent * 100
        
        mac2ios?.updateColor(uniqueIdentifier: brightnessCharcteristicIdentifier, value: brightness)
        
        self.update(hueFromHMKit: 360.0, saturationFromHMKit: 100.0, brightnessFromHMKit: brightness)
    }
    
    @IBAction override func changeColor(sender: NSMenuItem) {
        self.colorPanel = openColorPanel()

        self.colorPanel?.mode = .gray
        
        self.colorPanel?.title = self.accessoryName
        self.colorPanel?.color = self.color

        self.colorPanel?.setTarget(self)
        self.colorPanel?.setAction(#selector(self.colorDidChange(sender:)))
        self.colorPanel?.isContinuous = false
        self.colorPanel?.makeKeyAndOrderFront(self)

        if let app = NSWorkspace.shared.runningApplications.filter({ app in
            return app.bundleIdentifier == "com.sonson.HomeConMenu.macOS"
        }).first {
            app.activate(options: .activateIgnoringOtherApps)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class LightRGBColorMenuItem: LightColorMenuItem {
    let hueCharcteristicIdentifier: UUID
    let saturationCharcteristicIdentifier: UUID
    let brightnessCharcteristicIdentifier: UUID
    
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
        
        guard let hue = hueChara.value as? CGFloat,
              let saturation = saturationChara.value as? CGFloat,
              let brightness = brightnessChara.value as? CGFloat else { return nil }

        self.hueCharcteristicIdentifier = hueChara.uniqueIdentifier
        self.saturationCharcteristicIdentifier = saturationChara.uniqueIdentifier
        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
        
        super.init(accessoryInfo: accessoryInfo, serviceInfo: serviceInfo, mac2ios: mac2ios)
        
        let cp = CustomColorPanel()
        cp.mode = .wheel
        
        
        let v = NSColorWell(frame: NSRect(x: 0, y: 0, width: 240, height: 240))
        
        self.view = v
        self.colorPanel = cp
        
        self.colorPanel?.setTarget(self)
        self.colorPanel?.setAction(#selector(self.colorDidChange(sender:)))
        self.colorPanel?.isContinuous = false
        self.colorPanel?.makeKeyAndOrderFront(self)
        
//        self.color = NSColor(hue: hue / 360.0, saturation: saturation / 100.0, brightness: brightness / 100.0, alpha: 1.0)
//        self.action = #selector(self.changeColor(sender:))
//        self.image = createImage()
//        self.target = self
    }
    
    @objc override func colorDidChange(sender: NSColorPanel) {
        guard let panel = sender as? CustomColorPanel else { return }
        
        let hue = panel.color.hueComponent * 360.0
        let saturation = panel.color.saturationComponent * 100
        let brightness = panel.color.brightnessComponent * 100
        
        mac2ios?.updateColor(uniqueIdentifier: hueCharcteristicIdentifier, value: hue)
        mac2ios?.updateColor(uniqueIdentifier: saturationCharcteristicIdentifier, value: saturation)
        mac2ios?.updateColor(uniqueIdentifier: brightnessCharcteristicIdentifier, value: brightness)
        
        self.update(hueFromHMKit: hue, saturationFromHMKit: saturation, brightnessFromHMKit: brightness)
    }
    
    @IBAction override func changeColor(sender: NSMenuItem) {
        self.colorPanel = openColorPanel()

        self.colorPanel?.title = self.accessoryName
        self.colorPanel?.color = self.color

        self.colorPanel?.setTarget(self)
        self.colorPanel?.setAction(#selector(self.colorDidChange(sender:)))
        self.colorPanel?.isContinuous = false
        self.colorPanel?.makeKeyAndOrderFront(self)

        if let app = NSWorkspace.shared.runningApplications.filter({ app in
            return app.bundleIdentifier == "com.sonson.HomeConMenu.macOS"
        }).first {
            app.activate(options: .activateIgnoringOtherApps)
        }
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
