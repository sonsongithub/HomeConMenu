//
//  HomeInfo.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/08.
//

import Foundation

@objc(HomeInfoProtocol)
public protocol HomeInfoProtocol: NSObjectProtocol {
    init()
    var name: String? { get set }
    var uniqueIdentifier: UUID? { get set }
}

public class HomeInfo: NSObject, HomeInfoProtocol {
    public var name: String?
    public var uniqueIdentifier: UUID?
    
    required public override init() {
    }
}
