//
//  SettingsWindowController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/09/08.
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
        }
    }

}
