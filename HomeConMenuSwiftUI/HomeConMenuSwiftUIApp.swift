//
//  HomeConMenuSwiftUIApp.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/09/26.
//

import SwiftUI

@main
struct HomeConMenuSwiftUIApp: App {
    @NSApplicationDelegateAdaptor (TestController.self) var appDelegate
    
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
    }
    
    var body: some Scene {
        Settings {
            ContentView()
        }
    }
}
