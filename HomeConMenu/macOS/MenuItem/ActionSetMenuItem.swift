//
//  ActionSetMenuItem.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2022/05/06.
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
import os
import KeyboardShortcuts

class ActionSetMenuItem: NSMenuItem, MenuItemFromUUID {
    let uniqueIdentifier: UUID
    let actionUniqueIdentifiers: [UUID]
    var mac2ios: mac2iOS?
    
    func UUIDs() -> [UUID] {
        return [uniqueIdentifier] + actionUniqueIdentifiers
    }
    
    public enum SensorType {
        case temperature
        case humidity
        case unknown
    }
    
    func bind(with _uniqueIdentifier: UUID) -> Bool {
        return self.uniqueIdentifier == _uniqueIdentifier || actionUniqueIdentifiers.contains(_uniqueIdentifier)
    }
    
    func createImage(check: Bool) -> NSImage? {
        let view = NSView(frame: NSRect(x: 0, y: 0, width: 14, height: 14))
        view.wantsLayer = true
        view.translatesAutoresizingMaskIntoConstraints = false
        
        if check {
            view.layer?.backgroundColor = CGColor(red: 247.0/255.0, green: 148.0/255.0, blue: 30.0/255.0, alpha: 1)
        } else {
            view.layer?.backgroundColor = CGColor.init(gray: 0.5, alpha: 1.0)
        }
        
        let destinationSize = Double(14)
        
        guard let homeIcon = NSImage(named: "house") else {
            Logger.app.error("can not load house image.")
            return nil
        }
        
        let image = NSImage(size: NSSize(width: destinationSize, height: destinationSize))
        
        let width = Double(16)
        let height = Double(16)
        
        let x = (destinationSize - width) / 2
        let y = (destinationSize - height) / 2
        
        image.lockFocus()
        guard let ctx = NSGraphicsContext.current?.cgContext else {
            Logger.app.error("Can not get NSGraphicsContext for createing icon.")
            return nil
        }
        
        view.layer?.render(in: ctx)
        let source = NSRect(origin: CGPoint.zero, size: homeIcon.size)
        
        let destination = NSRect(x: x, y: y, width: width, height: height)
        
        homeIcon.draw(in: destination, from: source, operation: .destinationIn, fraction: 1)
        image.unlockFocus()

        return image
    }
    
    func update() {
        guard let mac2ios = mac2ios else { return }
        do {
            let actionSetInfo = try mac2ios.getActionSet(with: uniqueIdentifier)
            let targetValues = try mac2ios.getTargetValuesInActionSet(with: uniqueIdentifier)
            let currentValues = try actionUniqueIdentifiers.map { uuid in
                return try mac2ios.getCharacteristic(of: uuid)
            }
            guard targetValues.count == currentValues.count else { throw HomeConMenuError.actionSetCharacteristicsCountError(actionSetInfo.name, uniqueIdentifier, targetValues.count, currentValues.count) }
            
            let check = zip(targetValues, currentValues).reduce(true) { partialResult, tuple in
                switch tuple {
                case (let a as Int, let b as Int):
                    return partialResult && (a == b)
                case (let a as Double, let b as Double):
                    return partialResult && (a == b)
                default:
                    return false
                }
            }
            self.image = createImage(check: check)
            self.target = check ? nil : self
        } catch let error as HomeConMenuError {
            Logger.app.error("\(error.localizedDescription)")
        } catch {
            Logger.app.error("Can not get action item status from characteristic - \(error.localizedDescription)")
        }
    }

    override init(title string: String, action selector: Selector?, keyEquivalent charCode: String) {
        self.uniqueIdentifier = UUID()
        self.actionUniqueIdentifiers = []
        super.init(title: string, action: selector, keyEquivalent: charCode)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func execute(sender: NSMenuItem) {
        if let mac2ios = mac2ios {
            mac2ios.executeActionSet(uniqueIdentifier: uniqueIdentifier)
        }
    }
    
    @MainActor
    init(actionSetInfo: ActionSetInfoProtocol, mac2ios: mac2iOS?) {
        self.uniqueIdentifier = actionSetInfo.uniqueIdentifier
        self.mac2ios = mac2ios
        self.actionUniqueIdentifiers = actionSetInfo.actionUniqueIdentifiers
        super.init(title: actionSetInfo.name, action: nil, keyEquivalent: "")
        self.action = #selector(self.execute(sender:))
        self.target = self
        self.image = self.createImage(check: false)
        if let shortcutName = KeyboardShortcuts.Name(rawValue: actionSetInfo.uniqueIdentifier.uuidString) {
            self.setShortcut(for: shortcutName)
            KeyboardShortcuts.onKeyDown(for: shortcutName, action: {
                Logger.app.info("KeyboardShortcuts.onKeyDown")
                self.execute(sender: self)
            })
        }
    }
}
