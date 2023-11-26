//
//  SettingsWindowController.swift
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

import Foundation
import AppKit

final class SettingsWindowController: NSWindowController {
    // MARK: Lifecycle
    
    var settingsTabViewController: SettingsTabViewController?
    
    convenience init() {
        let viewController = SettingsTabViewController()
        viewController.tabStyle = .toolbar
        viewController.canPropagateSelectedChildViewControllerTitle = false
        viewController.tabViewItems = SettingsPane.allCases.map(\.tabViewItem)
        
        let window = SettingsWindow(contentViewController: viewController)
        window.styleMask = [.closable, .titled]
        window.hidesOnDeactivate = false
        window.isReleasedWhenClosed = true
        
        self.init(window: window)
        self.settingsTabViewController = viewController
    }
    
    
    // MARK: Public Methods
    
    /// Open specific setting pane.
    ///
    /// - Parameter pane: The pane to display.
    func openPane(_ pane: SettingsPane) {
        
        let index = SettingsPane.allCases.firstIndex(of: pane)!
        (self.contentViewController as? NSTabViewController)?.selectedTabViewItemIndex = index
        
        self.showWindow(nil)
        NSApp.activate(ignoringOtherApps: true)
    }
}


// MARK: -

private extension SettingsPane {
    
    var tabViewItem: NSTabViewItem {
        
        let viewController: NSViewController = self.resource
        
        let tabViewItem = NSTabViewItem(viewController: viewController)
        tabViewItem.label = self.label
        tabViewItem.image = NSImage(systemSymbolName: self.symbolName, accessibilityDescription: self.label)
        tabViewItem.identifier = self.rawValue
        
        return tabViewItem
    }
    
    private var resource: NSViewController {
        switch self {
        case .general:
            return GeneralPaneController(nibName: NSNib.Name("GeneralPane"), bundle: nil)
        case .shortcuts:
            return ShortcutsPaneController(nibName: NSNib.Name("ShortcutsPane"), bundle: nil)
        case .information:
            return InformationPaneController(nibName: NSNib.Name("InformationPane"), bundle: nil)
        case .donation:
            return DonationPaneController(nibName: NSNib.Name("DonationPane"), bundle: nil)
        }
    }

}
