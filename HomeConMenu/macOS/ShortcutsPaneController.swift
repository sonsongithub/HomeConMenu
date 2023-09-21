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
    
    @IBOutlet var line: NSView?
    
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
        if let textField = self.textField, let imageView = self.imageView, let line = self.line {
            self.addSubview(recorder)
            imageView.translatesAutoresizingMaskIntoConstraints = false
            recorder.translatesAutoresizingMaskIntoConstraints = false
            self.translatesAutoresizingMaskIntoConstraints = false
            line.translatesAutoresizingMaskIntoConstraints = false
            textField.translatesAutoresizingMaskIntoConstraints = false
            
            imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10).isActive = true
            
            textField.leadingAnchor.constraint(equalTo: imageView.trailingAnchor, constant: 10).isActive = true
            
            imageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
            imageView.heightAnchor.constraint(equalToConstant: 20).isActive = true
            
            imageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            
            
            textField.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
            recorder.centerYAnchor.constraint(equalTo: textField.centerYAnchor).isActive = true
            recorder.leadingAnchor.constraint(equalTo: textField.trailingAnchor, constant: 10).isActive = true
            recorder.heightAnchor.constraint(equalToConstant: 30).isActive = true
            recorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            recorder.widthAnchor.constraint(equalToConstant: 100).isActive = true
            line.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 0).isActive = true
            line.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 5).isActive = true
            line.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 0).isActive = true
            line.isHidden = false
        }
        self.layoutSubtreeIfNeeded()
        self.layout()
    }
}

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
        return 44
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        self.tableView?.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView?.headerView = nil
    }
    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return shortcutLabels.count
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("ShortcutCellView"), owner: self)
        if let view = view as? ShortcutCellView {
            view.textField?.stringValue = shortcutLabels[row].name
            view.imageView?.image = shortcutLabels[row].image
            if let r = KeyboardShortcuts.Name(rawValue: shortcutLabels[row].uniqueIdentifier.uuidString) {
                let recoder = KeyboardShortcuts.RecorderCocoa(for: r)
                view.addRecorder(recorder: recoder)
            }
        }
        return view
    }
}
