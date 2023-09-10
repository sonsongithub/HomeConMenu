//
//  SettingsPane.swift
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

enum SettingsPane: String, CaseIterable {
    
    case general
    case shortcuts
    case information
    
    /// Localized label.
    var label: String {
        
        switch self {
            case .general:
                return String(localized: "General")
            case .shortcuts:
                return String(localized: "Key Bindings")
            case .information:
                return String(localized: "Information")
        }
    }
    
    /// Symbol image name.
    var symbolName: String {
        
        switch self {
            case .general:
                return "gearshape"
            case .shortcuts:
                return "keyboard"
            case .information:
                return "info.circle.fill"
        }
    }
}
