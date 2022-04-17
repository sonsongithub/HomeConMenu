//
//  ServiceInfo.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/08.
//

import Foundation

#if !os(macOS)
import HomeKit
#endif

@objc(ServiceInfoProtocol)
public protocol ServiceInfoProtocol: NSObjectProtocol {
    init()
    var name: String? { get set }
    var uniqueIdentifier: UUID { get set }
    var isUserInteractive: Bool { get set }
    var characteristics: [CharacteristicInfoProtocol] { get set }
    var type: ServiceType { get set }
}

public class ServiceInfo: NSObject, ServiceInfoProtocol {
    public var name: String?
    public var uniqueIdentifier: UUID = UUID()
    public var isUserInteractive: Bool = false
    public var characteristics: [CharacteristicInfoProtocol] = []
    public var type: ServiceType = .unknown
    
    required public override init() {
        isUserInteractive = false
    }
#if !os(macOS)
    init(service: HMService) {
        super.init()
        name = service.name
        uniqueIdentifier = service.uniqueIdentifier
        isUserInteractive = service.isUserInteractive
        type = ServiceType(key: service.serviceType)
        characteristics = service.characteristics.map({ CharacteristicInfo(characteristic: $0) })
    }
#endif
}
