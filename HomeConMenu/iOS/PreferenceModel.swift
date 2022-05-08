//
//  PreferenceModel.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/07.
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

class PreferenceModel: ObservableObject {
    @Published var doesNotShowLaunchViewController: Bool {
        didSet {
            UserDefaults.standard.set(doesNotShowLaunchViewController, forKey: "doesNotShowLaunchViewController")
        }
    }
    
    @Published var allowDuplicatingServices: Bool {
        didSet {
            UserDefaults.standard.set(allowDuplicatingServices, forKey: "allowDuplicatingServices")
        }
    }
    
    @Published var useScenes: Bool {
        didSet {
            UserDefaults.standard.set(useScenes, forKey: "useScenes")
        }
    }
    
    init() {
        if let doesNotShowLaunchViewController = UserDefaults.standard.object(forKey: "doesNotShowLaunchViewController") as? Bool {
            self.doesNotShowLaunchViewController = doesNotShowLaunchViewController
        } else {
            self.doesNotShowLaunchViewController = false
        }
        
        if let allowDuplicatingServices = UserDefaults.standard.object(forKey: "allowDuplicatingServices") as? Bool {
            self.allowDuplicatingServices = allowDuplicatingServices
        } else {
            self.allowDuplicatingServices = false
        }
    
        if let useScenes = UserDefaults.standard.object(forKey: "useScenes") as? Bool {
            self.useScenes = useScenes
        } else {
            self.useScenes = false
        }
    }
}
