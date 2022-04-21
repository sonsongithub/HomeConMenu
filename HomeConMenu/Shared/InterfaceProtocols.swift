//
//  MacOSBridge.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/02.
//

import Foundation
@objc(iOS2Mac)
public protocol iOS2Mac: NSObjectProtocol {
    init()
    var iosListener: mac2iOS? { get set }
    var menuItemCount: Int { get }
    func didUpdate()
    func bringToFront()
    func centeringWindows()
    func didUpdate(chracteristicInfo: CharacteristicInfoProtocol)
}

@objc(mac2iOS)
public protocol mac2iOS: NSObjectProtocol {
    func reload(uniqueIdentifiers: [UUID])
    var accessories: [AccessoryInfoProtocol] { get set }
    var serviceGroups: [ServiceGroupInfoProtocol] { get set }
    var rooms: [RoomInfoProtocol] { get set }
    func toggleValue(uniqueIdentifier: UUID)
    func openCamera(uniqueIdentifier: UUID)
    func updateColor(uniqueIdentifier: UUID, value: Double)
}
