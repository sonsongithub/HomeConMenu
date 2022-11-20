//
//  HCCommunication.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/10/24.
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

class HCCommunication : Codable {
    let rooms: [HCRoom]
    let actionSets: [HCActionSet]
    let accessories: [HCAccessory]
    let serviceGroups: [HCServiceGroup]
    
    func excludedAccessories() -> [HCAccessory] {
        return accessories.filter { accessory in
            return (accessory.room == nil)
        }
    }
    
    func accessories(in room: HCRoom) -> [HCAccessory] {
        return accessories.filter { accessory in
            return (accessory.room == room)
        }
    }
    
#if !os(macOS)
    init(with home: HMHome) {
        accessories = home
            .accessories
            .map({HCAccessory(with: $0)})
            .filter({$0.isAvailable})
        serviceGroups = home.serviceGroups.map({HCServiceGroup(serviceGroup: $0)})
        rooms = home.rooms.map({HCRoom(with: $0)})
        actionSets = home.actionSets
            .filter({ $0.isHomeKitScene })
            .map({HCActionSet(actionSet: $0)})
    }
#endif
}
