//
//  PreferenceView.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/06.
//

import SwiftUI

struct PreferenceView: View {
    
    @State var doesNotShowLaunchViewController = false
    @State var duplicateServices = false
    @State var useScenes = false
    
    var spacer: some View {
        Spacer(minLength: 0)
            .frame(height: 32)
    }
    
    var body: some View {
        
        VStack {
            GroupBox {
                VStack(alignment: .leading) {
                    Toggle(isOn: $doesNotShowLaunchViewController) {
                        Spacer(minLength: 0)
                            .frame(width: 5)
                        Text("Do not show welcome message when launching")
                    }
                    Toggle(isOn: $duplicateServices) {
                        Spacer(minLength: 0)
                            .frame(width: 5)
                        Text("Allow duplicate services to be displayed")
                    }
                    Toggle(isOn: $useScenes) {
                        Spacer(minLength: 0)
                            .frame(width: 5)
                        Text("Use scenes")
                    }
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            
            
        }
        .padding()
        .onAppear {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.baseManager?.macOSController?.bringToFront()
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    
    static var previews: some View {
        PreferenceView()
            .previewLayout(.fixed(width: (480), height: (320)))
    }
}
