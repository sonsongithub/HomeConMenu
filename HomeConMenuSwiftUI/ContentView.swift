//
//  ContentView.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/09/26.
//

import SwiftUI

extension NSNotification.Name {
    static let testNotification = Self("testNotification")
}


struct ContentView: View {
    
  //  @objc private func timerUpdate() {
        
    //}
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
            Button(action: {
                print("tap buton")
                DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                    print("fire")
                    NotificationCenter.default.post(name: .testNotification, object: nil)
                }
            }) {
                Text("Button")
            }
        }
        .padding()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
