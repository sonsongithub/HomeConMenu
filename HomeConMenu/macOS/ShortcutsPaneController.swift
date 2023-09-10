//
//  ShortcutsPaneController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/08.
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
//            textField.sizeToFit()
            recorder.heightAnchor.constraint(equalToConstant: 30).isActive = true
            recorder.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -20).isActive = true
            recorder.widthAnchor.constraint(equalToConstant: 100).isActive = true
        }
        self.layoutSubtreeIfNeeded()
        self.layout()
    }
}

class ShortcutsPaneController: NSViewController, NSTableViewDataSource, NSTableViewDelegate {
    
    var names: [String] = []
    
    @IBOutlet var tableView: NSTableView?
    
    @IBAction func didPushResetButton(sender: NSButton) {
        KeyboardShortcuts.reset(names.compactMap({ KeyboardShortcuts.Name($0) }))
        self.tableView?.reloadData()
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
        return names.count
    }
    
    func tableView(_ tableView: NSTableView, shouldSelectRow row: Int) -> Bool {
        return false
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
        let view = tableView.makeView(withIdentifier: NSUserInterfaceItemIdentifier("ShortcutCellView"), owner: self)
        if let view = view as? ShortcutCellView {
            view.textField?.stringValue = names[row]
            if let r = KeyboardShortcuts.Name(rawValue: names[row]) {
                let recoder = KeyboardShortcuts.RecorderCocoa(for: r)
                view.addRecorder(recorder: recoder)
            }
        }
        return view
    }
}
