//
//  HCHome.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/10/08.
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

#if !os(macOS)
import HomeKit
#endif

extension NSNotification.Name {
    static let didUpdateAllItems = Self("to_macNotification")
    static let didUpdateCharacteristic = Self("chara_notify")
    static let to_iosNotification = Self("to_iOSNotification")
    
    static let terminate_iOSNotification = Self("terminate_iOSNotification")
    static let terminate_SwiftUINotification = Self("terminate_SwiftUINotification")
}

class HCHome: Codable {
    var homeName: String
    let uniqueIdentifier: UUID
    var rooms: [HCRoom]
#if !os(macOS)
    init(with _hmhome: HMHome) {
        homeName = _hmhome.name
        uniqueIdentifier = _hmhome.uniqueIdentifier
        rooms = _hmhome.rooms.map({HCRoom(with: $0)})
    }
#endif
}
