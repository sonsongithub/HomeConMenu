//
//  ShortcutsPaneController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/08.
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

import AppKit
import KeyboardShortcuts

class ShortcutsPaneController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var shortcutLabels: [ShortcutInfo] = []
    
    @IBOutlet var tableView: NSTableView?
    
    @IBAction func didPushResetButton(sender: NSButton) {
        
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Key Bindings", comment: "")
        alert.informativeText = NSLocalizedString("You will remove all key bindings settings. Are you sure to remove them?", comment:"")
        alert.alertStyle = .critical
        
        alert.addButton(withTitle: NSLocalizedString("Remove all", comment: ""))
        alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
        
        let ret = alert.runModal()
        if ret == .alertFirstButtonReturn {
            KeyboardShortcuts.reset(shortcutLabels.compactMap({ KeyboardShortcuts.Name($0.uniqueIdentifier.uuidString) }))
            self.tableView?.reloadData()
        }
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 30
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.tableView?.reloadData()
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return shortcutLabels.count
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        guard let tableColumn = tableColumn else { return nil }
        
        if tableColumn.identifier == NSUserInterfaceItemIdentifier(rawValue: "Device") {
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("DeviceCell"), owner: self)
            if let view = view as? NSTableCellView {
                view.imageView?.image = shortcutLabels[row].image
                view.textField?.stringValue = shortcutLabels[row].name
            }
            return view
        } else if tableColumn.identifier == NSUserInterfaceItemIdentifier(rawValue: "Key") {
            let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("KeyCell"), owner: self)
            if let view = view as? NSTableCellView {
                view.subviews.forEach { view in
                    view.removeFromSuperview()
                }
                if let r = KeyboardShortcuts.Name(rawValue: shortcutLabels[row].uniqueIdentifier.uuidString) {
                    let recorder = KeyboardShortcuts.RecorderCocoa(for: r)
                    view.addSubview(recorder)
                    view.translatesAutoresizingMaskIntoConstraints = false
                    recorder.translatesAutoresizingMaskIntoConstraints = false
                    view.trailingAnchor.constraint(equalTo: recorder.trailingAnchor, constant: 0).isActive = true
                    recorder.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
                    recorder.heightAnchor.constraint(equalToConstant: 20).isActive = true
                    view.centerYAnchor.constraint(equalTo: recorder.centerYAnchor).isActive = true
                    recorder.bezelStyle = .squareBezel
                }
            }
            return view
        }
        return nil
    }
}
