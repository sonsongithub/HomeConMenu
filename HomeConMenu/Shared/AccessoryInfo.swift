//
//  AccessoryInfo.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/08.
//

import Foundation

@objc(AccessoryInfoProtocol)
public protocol AccessoryInfoProtocol: NSObjectProtocol {
    init()
    var home: HomeInfoProtocol? { get set }
    var room: RoomInfoProtocol? { get set }
    
    var name: String? { get set }
    var uniqueIdentifier: UUID { get set }
    
    var hasCamera: Bool { get set }
    
    var services: [ServiceInfoProtocol] { get set }
    
    var type: AccessoryType { get set }
}

public class AccessoryInfo: NSObject, AccessoryInfoProtocol {
    public var home: HomeInfoProtocol?
    public var room: RoomInfoProtocol?
    
    public var name: String?
    public var uniqueIdentifier: UUID = UUID()
    
    public var services: [ServiceInfoProtocol] = []
    
    public var type: AccessoryType = .unknown
    
    public var hasCamera: Bool = false
    
    required public override init() {
    }
}
