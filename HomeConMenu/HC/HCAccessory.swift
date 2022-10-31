//
//  HCAccessory.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/10/24.
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

class HCAccessory: Codable {
    var accessoryName: String = ""
    let uniqueIdentifier: UUID
    let type: HCAccessoryType
    var serivces: [HCService] = []
    var room: HCRoom? = nil

#if !os(macOS)
    init(with _hmaccessory: HMAccessory) {
        accessoryName = _hmaccessory.name
        uniqueIdentifier = _hmaccessory.uniqueIdentifier
        type = HCAccessoryType(key: _hmaccessory.category.categoryType)
        if let temp = _hmaccessory.room {
            room = HCRoom(with: temp)
        } else {
            room = nil
        }
        serivces = _hmaccessory
            .services
            .map({HCService(with: $0)})
            .filter({$0.isSupported})
    }
#endif
    
    var isAvailable: Bool {
        serivces.count > 0
    }
}