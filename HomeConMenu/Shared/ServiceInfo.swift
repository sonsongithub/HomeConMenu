//
//  ServiceInfo.swift
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

@objc(ServiceInfoProtocol)
public protocol ServiceInfoProtocol: NSObjectProtocol {
    init()
    var name: String { get set }
    var uniqueIdentifier: UUID { get set }
    var isUserInteractive: Bool { get set }
    var characteristics: [CharacteristicInfoProtocol] { get set }
    var type: ServiceType { get set }
}

public class ServiceInfo: NSObject, ServiceInfoProtocol {
    public var name: String
    public var uniqueIdentifier: UUID = UUID()
    public var isUserInteractive: Bool = false
    public var characteristics: [CharacteristicInfoProtocol] = []
    public var type: ServiceType = .unknown
    
    required public override init() {
        fatalError()
    }
#if !os(macOS)
    init(service: HMService) {
        name = service.name
        uniqueIdentifier = service.uniqueIdentifier
        isUserInteractive = service.isUserInteractive
        type = ServiceType(key: service.serviceType)
        characteristics = service.characteristics.map({ CharacteristicInfo(characteristic: $0) })
        super.init()
    }
#endif
}
