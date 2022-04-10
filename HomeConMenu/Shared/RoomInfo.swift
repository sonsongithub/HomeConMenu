//
//  SceneInfo.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/08.
//

import Foundation

@objc(RoomInfoProtocol)
public protocol RoomInfoProtocol: NSObjectProtocol {
    init()
    var name: String? { get set }
    var uniqueIdentifier: UUID? { get set }
}

public class RoomInfo: NSObject, RoomInfoProtocol {
    public var name: String?
    public var uniqueIdentifier: UUID?
    
    public init(name: String, uniqueIdentifier: UUID) {
        self.name = name
        self.uniqueIdentifier = uniqueIdentifier
        super.init()
    }
    
    required public override init() {
    }
}
