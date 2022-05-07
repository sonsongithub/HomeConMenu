//
//  PreferenceView.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/06.
//

import SwiftUI

struct PreferenceView: View {

    @ObservedObject var model = PreferenceModel()

    var spacer: some View {
        Spacer(minLength: 0)
            .frame(height: 32)
    }
    
    var body: some View {
        
        VStack {
            GroupBox {
                VStack(alignment: .leading) {
                    Toggle(isOn: $model.doesNotShowLaunchViewController) {
                        Spacer(minLength: 0)
                            .frame(width: 5)
                        Text(NSLocalizedString("Do not show welcome message when launching", comment: ""))
                    }
                    Toggle(isOn: $model.allowDuplicatingServices) {
                        Spacer(minLength: 0)
                            .frame(width: 5)
                        Text(NSLocalizedString("Allow duplicate services to be displayed", comment: ""))
                    }
                    Toggle(isOn: $model.useScenes) {
                        Spacer(minLength: 0)
                            .frame(width: 5)
                        Text(NSLocalizedString("Use scenes", comment: ""))
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
        .onDisappear {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
            appDelegate.baseManager?.macOSController?.isOpenedPreference = false
            appDelegate.baseManager?.reloadAllItems()
        }
    }
}

struct PreferenceView_Previews: PreviewProvider {
    
    static var previews: some View {
        PreferenceView()
            .previewLayout(.fixed(width: (480), height: (320)))
    }
}
