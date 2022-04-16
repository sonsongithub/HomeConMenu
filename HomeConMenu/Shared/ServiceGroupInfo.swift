//
//  ServiceGroupInfo.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/04/12.
//

import Foundation

#if !os(macOS)
import HomeKit
#endif

@objc(ServiceGroupInfoProtocol)
public protocol ServiceGroupInfoProtocol: NSObjectProtocol {
    init()
    var name: String? { get set }
    var uniqueIdentifier: UUID { get set }
    var services: [ServiceInfo] { get set }
}

public class ServiceGroupInfo: NSObject, ServiceGroupInfoProtocol {
    public var name: String?
    public var uniqueIdentifier: UUID = UUID()
    public var services: [ServiceInfo] = []
    
    required public override init() {
    }
#if !os(macOS)
    init(serviceGroup: HMServiceGroup) {
        super.init()
        name = serviceGroup.name
        uniqueIdentifier = serviceGroup.uniqueIdentifier
        services = serviceGroup.services.map({ ServiceInfo(service: $0) })
    }
#endif
}
