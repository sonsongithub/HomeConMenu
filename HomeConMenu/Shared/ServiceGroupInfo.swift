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
    var services: [ServiceInfoProtocol] { get set }
}

public class ServiceGroupInfo: NSObject, ServiceGroupInfoProtocol {
    public var name: String?
    public var uniqueIdentifier: UUID = UUID()
    public var services: [ServiceInfoProtocol] = []
    public var commonCharacteristicTypes: [CharacteristicType] = []
    
    required public override init() {
    }
#if !os(macOS)
    init(serviceGroup: HMServiceGroup) {
        super.init()
        name = serviceGroup.name
        uniqueIdentifier = serviceGroup.uniqueIdentifier
        services = serviceGroup.services.map({ ServiceInfo(service: $0) })
        var buffer = Set(services[0].characteristics.map({ $0.type }))
        
        for service in services {
            buffer = Set(service.characteristics.map({$0.type})).intersection(buffer)
        }
        commonCharacteristicTypes = Array(buffer)
        print("-----------------------")
        print(name)
        for type in commonCharacteristicTypes {
            print(type)
        }
    }
#endif
}
