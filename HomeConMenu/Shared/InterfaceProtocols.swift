//
//  MacOSBridge.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/02.
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
@objc(iOS2Mac)
public protocol iOS2Mac: NSObjectProtocol {
    init()
    var iosListener: mac2iOS? { get set }
    var menuItemCount: Int { get }
    func didUpdate()
    func bringToFront()
    func centeringWindows()
    func didUpdate(chracteristicInfo: CharacteristicInfoProtocol)
    func openHomeKitAuthenticationError() -> Bool
    func openNoHomeError()
    var isOpenedPreference: Bool { get set }
}

@objc(mac2iOS)
public protocol mac2iOS: NSObjectProtocol {
    func openAbout()
    func openPreferences()
    func reload(uniqueIdentifiers: [UUID])
    var accessories: [AccessoryInfoProtocol] { get set }
    var serviceGroups: [ServiceGroupInfoProtocol] { get set }
    var rooms: [RoomInfoProtocol] { get set }
    var actionSets: [ActionSetInfoProtocol] { get set }
    func toggleValue(uniqueIdentifier: UUID)
    func getPowerState(uniqueIdentifier: UUID) -> Bool
    func setPowerState(uniqueIdentifier: UUID, state: Bool)
    func openCamera(uniqueIdentifier: UUID)
    func updateColor(uniqueIdentifier: UUID, value: Double)
    func executeActionSet(uniqueIdentifier: UUID)
}
