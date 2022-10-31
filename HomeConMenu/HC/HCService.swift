//
//  HCService.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/10/09.
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

class HCService : Codable {
    var serviceName: String
    let uniqueIdentifier: UUID
    var isUserInteractive: Bool
    var characteristics: [HCCharacteristic]
    let type: HCServiceType
    
    var id: UUID {
        uniqueIdentifier
    }
    
    init() {
        serviceName = ""
        uniqueIdentifier = UUID()
        isUserInteractive = false
        characteristics = []
        type = .unknown
    }
#if !os(macOS)
    init(with _hmservice: HMService) {
        serviceName = _hmservice.name
        uniqueIdentifier = _hmservice.uniqueIdentifier
        type = HCServiceType(key: _hmservice.serviceType)
        isUserInteractive = _hmservice.isUserInteractive
        characteristics = _hmservice
            .characteristics
            .map({ HCCharacteristic(with: $0)})
    }
#endif
    
    var isSupported: Bool {
        let supportedTypes: [HCServiceType] = [.humiditySensor, .temperatureSensor, .lightbulb, .switch, .outlet]
        return supportedTypes.contains {
            $0 == self.type
        }
    }
}

