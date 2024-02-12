//
//  ServiceGroupInfo.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/04/12.
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

/// Protocol to describe service group information.
@objc(ServiceGroupInfoProtocol)
public protocol ServiceGroupInfoProtocol: NSObjectProtocol {
    init()
    /// Name of service group.
    var name: String { get set }
    /// Unique identifier of service group.
    var uniqueIdentifier: UUID { get set }
    /// Services in service group.
    var services: [ServiceInfoProtocol] { get set }
    /// Common characteristic types in service group.
    var commonCharacteristicTypes: [CharacteristicInfo] { get set }
}

public class ServiceGroupInfo: NSObject, ServiceGroupInfoProtocol {
    public var name: String
    public var uniqueIdentifier: UUID = UUID()
    public var services: [ServiceInfoProtocol] = []
    public var commonCharacteristicTypes: [CharacteristicInfo] = []
    
    required public override init() {
        fatalError()
    }
#if !os(macOS)
    init(serviceGroup: HMServiceGroup) {
        name = serviceGroup.name
        uniqueIdentifier = serviceGroup.uniqueIdentifier
        services = serviceGroup.services.map({ ServiceInfo(service: $0) })
        super.init()
    }
#endif
}
