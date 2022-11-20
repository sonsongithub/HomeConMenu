//
//  HCCharacteristic.swift
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

class HCCharacteristic: Codable {
    var charName: String
    let uniqueIdentifier: UUID
    var stringValue: String? = nil {
        didSet {
            if let stringValue {
                string = stringValue
            }
        }
    }
//
//    var numberValue: Float? = nil {
//        didSet {
//            if let numberValue {
//                string = "\(numberValue)"
//            }
//        }
//    }
    
    var doubleValue: Double? = nil {
        didSet {
            if let doubleValue {
                string = "\(doubleValue)"
            }
        }
    }
//    var intValue: Int? = nil {
//        didSet {
//            if let intValue {
//                string = "\(intValue)"
//            }
//        }
//    }
//    var boolValue: Bool? = nil {
//        didSet {
//            if let boolValue {
//                string = "\(boolValue)"
//            }
//        }
//    }
    let type: HCCharacteristicType
    
    var string: String = ""
    
    init() {
        charName = ""
        uniqueIdentifier = UUID()
        type = .unknown
    }
    
    var id: UUID {
        uniqueIdentifier
    }
    
    var message: String {
        if let stringValue {
            return stringValue
//        } else if let numberValue {
//            return "\(numberValue)"
//        } else if let intValue {
//            return "\(intValue)"
//        } else if let boolValue {
//            return "\(boolValue)"
        } else if let doubleValue {
            return "\(doubleValue)"
        }
        return "None"
    }
    
#if !os(macOS)
    init(with _hmcharacteristic: HMCharacteristic) {
        charName = _hmcharacteristic.localizedDescription
        uniqueIdentifier = _hmcharacteristic.uniqueIdentifier
        type = HCCharacteristicType(key: _hmcharacteristic.characteristicType)
        stringValue = nil
//        numberValue = nild
        doubleValue = nil
        
//        print("\(_hmcharacteristic.descriptionType.description) - \(_hmcharacteristic.value)")
        
        if let value = _hmcharacteristic.value as? String {
            stringValue = value
        } else if let value = _hmcharacteristic.value as? Double {
            doubleValue = value
        } else {
            print("can not convert - \(_hmcharacteristic.value)")
        }
//
//        if let value = _hmcharacteristic.value as? String {
//            stringValue = value
//        } else if let value = _hmcharacteristic.value as? Float {
//            numberValue = value
//        } else if let value = _hmcharacteristic.value as? Int {
//            intValue = value
//        } else if let value = _hmcharacteristic.value as? Bool {
//            boolValue = value
//        } else if let value = _hmcharacteristic.value as? Double {
//            doubleValue = value
//        } else {
//            print("can not convert")
//        }
    }
#endif
}
