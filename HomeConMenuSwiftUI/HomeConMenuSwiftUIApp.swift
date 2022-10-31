//
//  HomeConMenuSwiftUIApp.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/09/26.
//

import SwiftUI

@main
struct HomeConMenuSwiftUIApp: App {
    @AppStorage("showMenuBar") var showMenuBar = true
    
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
//    let testController = TestController()
    
    static var shared: HomeConMenuSwiftUIApp!
    
    
    var sharedKey: String? = nil {
        didSet {
            if let sharedKey = sharedKey {
//                let alert = NSAlert()
//                alert.messageText = NSLocalizedString("Shared key", comment: "")
//                alert.informativeText = NSLocalizedString(sharedKey, comment:"")
//                alert.alertStyle = .informational
//                alert.addButton(withTitle: "OK")
//                _ = alert.runModal()
            }
        }
    }
    
    init() {
        HomeConMenuSwiftUIApp.shared = self
//        if let button = self.statusItem.button {
//            button.image = NSImage.init(systemSymbolName: "house.circle", accessibilityDescription: nil)
//        }
//        self.statusItem.menu = mainMenu
////        mainMenu.delegate = self
        
        
//        let mainMenu = NSMenu()
//        let statusItem = NSStatusBar.system.statusItem(withLength:NSStatusItem.squareLength)
    }
    
    var body: some Scene {
//        WindowGroup {
//            ContentView()
//        }
        MenuBarExtra("HTTP Status Code", systemImage: "number.circle", isInserted: $showMenuBar) {
            List {
                VStack(spacing: 0) {
                    Text("Hello, world!")
                    Text("Hello, world!")
                    Text("Hello, world!")
                }
            }
            Menu(content: {
                Text("aaaaaa")
            }) {
                Image(systemName: "checkmark")
                Text("aa")
            }
//            MenuView(appDelegate: appDelegate)
//            Text("Hello, world!")
//            Image(systemName: "globe")
//            Rectangle()
            SUColorPanel()
        }.menuBarExtraStyle(.window)
    }
}
