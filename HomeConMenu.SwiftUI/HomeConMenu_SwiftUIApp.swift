//
//  HomeConMenu_SwiftUIApp.swift
//  HomeConMenu.SwiftUI
//
//  Created by Yuichi Yoshida on 2022/09/24.
//

import SwiftUI

@main
struct HomeConMenu_SwiftUIApp: App {
    
    var connectionManager = ConnectionManager()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(connectionManager)
        }
    }
}
