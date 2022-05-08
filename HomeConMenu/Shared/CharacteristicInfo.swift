//
//  Characteristics.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/08.
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

@objc(CharacteristicInfoProtocol)
public protocol CharacteristicInfoProtocol: NSObjectProtocol {
    init()
    var uniqueIdentifier: UUID { get set }
    var value: Any? { get set }
    var type: CharacteristicType { get set }
}

public class CharacteristicInfo: NSObject, CharacteristicInfoProtocol {
    public var uniqueIdentifier: UUID = UUID()
    public var value: Any?
    public var type: CharacteristicType = .unknown
    
    required public override init() {
        fatalError()
    }
#if !os(macOS)
    init(characteristic: HMCharacteristic) {
        super.init()
        uniqueIdentifier = characteristic.uniqueIdentifier
        value = characteristic.value
        type = CharacteristicType(key: characteristic.characteristicType)
    }
#endif
}

