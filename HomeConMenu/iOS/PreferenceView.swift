//
//  PreferenceView.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/06.
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

import SwiftUI

struct PreferenceView: View {

    @ObservedObject var model = PreferenceModel()
    
    let version: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "?.?.?"
    let build: String = Bundle.main.object(forInfoDictionaryKey: "CFBundleVersion") as? String ?? "?"

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
                        Text(NSLocalizedString("Do not show welcome message on launch", comment: ""))
                    }
                    Toggle(isOn: $model.allowDuplicatingServices) {
                        Spacer(minLength: 0)
                            .frame(width: 5)
                        Text(NSLocalizedString("Display duplicate services", comment: ""))
                    }
                    Toggle(isOn: $model.useScenes) {
                        Spacer(minLength: 0)
                            .frame(width: 5)
                        Text(NSLocalizedString("Use scenes", comment: ""))
                    }
                    
                    Spacer(minLength: 0)
                    
                    Text("version: \(version)(\(build))")
                        .font(.caption)
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
