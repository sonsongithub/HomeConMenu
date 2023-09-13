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

class ShortcutCellView: NSTableCellView {
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        self.subviews.forEach { aView in
            if aView is KeyboardShortcuts.RecorderCocoa {
                aView.removeFromSuperview()
            }
        }
    }
    
    func addRecorder(recorder: NSView) {
        if let textField = textField {
            self.addSubview(recorder)
            recorder.translatesAutoresizingMaskIntoConstraints = false
            self.translatesAutoresizingMaskIntoConstraints = false
            textField.translatesAutoresizingMaskIntoConstraints = false
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            textField.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            recorder.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
            recorder.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10).isActive = true
            recorder.heightAnchor.constraint(equalToConstant: 30).isActive = true
            recorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            recorder.widthAnchor.constraint(equalToConstant: 100).isActive = true
        }
        self.layoutSubtreeIfNeeded()
        self.layout()
    }
}

class ShortcutsPaneController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var shortcutInfos: [ShortcutInfo] = []
    
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
            KeyboardShortcuts.reset(shortcutInfos.compactMap({ KeyboardShortcuts.Name($0.uuid.uuidString) }))
            self.tableView?.reloadData()
        }
    }
    
    func tableView(_ tableView: NSTableView, heightOfRow row: Int) -> CGFloat {
        return 44
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.headerView = nil
        self.tableView?.gridStyleMask = .solidHorizontalGridLineMask
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return shortcutInfos.count
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("ShortcutCellView"), owner: self)
        if let view = view as? ShortcutCellView {
            view.textField?.stringValue = shortcutInfos[row].name
            if let r = KeyboardShortcuts.Name(rawValue: shortcutInfos[row].uuid.uuidString) {
                let recoder = KeyboardShortcuts.RecorderCocoa(for: r)
                view.addRecorder(recorder: recoder)
            }
        }
        return view
    }
}
