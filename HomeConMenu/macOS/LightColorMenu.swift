//
//  LightColorMenu.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/03/20.
//

import Cocoa

class LightColorMenu: NSMenuItem, NSWindowDelegate, MenuFromUUID {

    func UUIDs() -> [UUID] {
        [hueCharcteristicIdentifier, saturationCharcteristicIdentifier, brightnessCharcteristicIdentifier]
    }
    
    func bind(with uniqueIdentifier: UUID) -> Bool {
        return hueCharcteristicIdentifier == uniqueIdentifier || saturationCharcteristicIdentifier == uniqueIdentifier || brightnessCharcteristicIdentifier == uniqueIdentifier
    }
    
    let hueCharcteristicIdentifier: UUID
    let saturationCharcteristicIdentifier: UUID
    let brightnessCharcteristicIdentifier: UUID
    
    var color = NSColor.white
    var mac2ios: mac2iOS?
    
    var colorPanel: CustomColorPanel?
    let accessoryName: String
    
    deinit {
        print("LightColorMenu deinit")
        self.colorPanel?.performClose(self)
    }
    
    @objc func colorDidChange(sender: NSColorPanel) {
        guard let panel = sender as? CustomColorPanel else { return }
        
        
        let hue = panel.color.hueComponent * 360.0
        let saturation = panel.color.saturationComponent * 100
        let brightness = panel.color.brightnessComponent * 100
        
        if let uniqueIdentifier = panel.hueCharcteristicIdentifier {
            mac2ios?.updateColor(uniqueIdentifier: uniqueIdentifier, value: hue)
        }
        if let uniqueIdentifier = panel.saturationCharcteristicIdentifier {
            mac2ios?.updateColor(uniqueIdentifier: uniqueIdentifier, value: saturation)
        }
        if let uniqueIdentifier = panel.brightnessCharcteristicIdentifier {
            mac2ios?.updateColor(uniqueIdentifier: uniqueIdentifier, value: brightness)
        }

        self.update(hueFromHMKit: hue, saturationFromHMKit: saturation, brightnessFromHMKit: brightness)
    }
    
    func windowShouldClose(_ sender: NSWindow) -> Bool {
        self.colorPanel = nil
        return true
    }
    
    @IBAction func changeColor(sender: NSMenuItem) {
        if let colorPanel = colorPanel {
            self.colorPanel = nil
            colorPanel.performClose(nil)
        }
        let cp = CustomColorPanel()
        cp.delegate = self
        guard let lightColorMenu = sender as? LightColorMenu else { return }
        
        self.colorPanel = cp
        cp.hueCharcteristicIdentifier = lightColorMenu.hueCharcteristicIdentifier
        cp.saturationCharcteristicIdentifier = lightColorMenu.saturationCharcteristicIdentifier
        cp.brightnessCharcteristicIdentifier = lightColorMenu.brightnessCharcteristicIdentifier
        
        cp.title = self.accessoryName
        cp.color = self.color
        
        cp.setTarget(self)
        cp.setAction(#selector(LightColorMenu.colorDidChange(sender:)))
        cp.isContinuous = false
        cp.makeKeyAndOrderFront(self)
    
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
    
//    init(accessoryName: String,
//         hueCharcteristicIdentifier: UUID,
//         saturationCharcteristicIdentifier: UUID,
//         brightnessCharcteristicIdentifier: UUID,
//         hue: CGFloat,
//         saturation: CGFloat,
//         brightness: CGFloat
//    ) {
//        self.accessoryName = accessoryName
//        self.hueCharcteristicIdentifier = hueCharcteristicIdentifier
//        self.saturationCharcteristicIdentifier = saturationCharcteristicIdentifier
//        self.brightnessCharcteristicIdentifier = brightnessCharcteristicIdentifier
//        self.color = NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: 1.0)
//        super.init(title: "Change color", action: nil, keyEquivalent: "")
//        self.image = createImage()
//    }
    
    init?(accessoryInfo: AccessoryInfoProtocol, serviceInfo: ServiceInfoProtocol, mac2ios: mac2iOS?) {
        guard let hueChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .hue
        }) else { return nil }
        guard let saturationChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .saturation
        }) else { return nil }
        guard let brightnessChara = serviceInfo.characteristics.first(where: { obj in
            obj.type == .brightness
        }) else { return nil }
        
        guard let hue = hueChara.value as? CGFloat,
              let saturation = saturationChara.value as? CGFloat,
              let brightness = brightnessChara.value as? CGFloat else { return nil }
        
        self.mac2ios = mac2ios
        self.accessoryName = accessoryInfo.name ?? ""
        self.hueCharcteristicIdentifier = hueChara.uniqueIdentifier
        self.saturationCharcteristicIdentifier = saturationChara.uniqueIdentifier
        self.brightnessCharcteristicIdentifier = brightnessChara.uniqueIdentifier
        self.color = NSColor(hue: hue / 360.0, saturation: saturation / 100.0, brightness: brightness / 100.0, alpha: 1.0)
        super.init(title: "Change color", action: nil, keyEquivalent: "")
        self.action = #selector(LightColorMenu.changeColor(sender:))
        self.image = createImage()
        self.target = self
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
        self.hueCharcteristicIdentifier = UUID()
        self.saturationCharcteristicIdentifier = UUID()
        self.brightnessCharcteristicIdentifier = UUID()
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
