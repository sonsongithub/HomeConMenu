//
//  MenuData.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/30.
//

import Foundation

class MenuData: ObservableObject {
    
    @Published var rooms: [SURoom] = []
    @Published var otherAccesories: [SUAccessory] = []
    @Published var dirty: Bool = false
    
    init() {
//        
//        var char_switch1 = SUSwitch(name: "hoge1")
//        var char_switch2 = SUHumidity(name: "hoge2")
//        var char_switch3 = SUTemperature(name: "hoge3")
//        
//        var acc_switch = SUAccessory(name: "switch1")
//        
//        acc_switch.charateristics = [char_switch1, char_switch2, char_switch3]
//        
//        var room1 = SURoom(name: "living")
//        
//        room1.accessories = [
//            acc_switch
//        ]
        
        rooms = []
        
        NotificationCenter.default.addObserver(self, selector: #selector(receiveTestNotification), name: .testNotification, object: nil)
    }
    
    @objc func receiveTestNotification(_ notification: Notification) {
//        items.remove(at: 0)
//        rooms[0].accessories[0].charateristics[0].name = "sonsonsonsonsonson"
        rooms[0].name = "eu2eu9328ehi3uhe"
        dirty = !dirty
    }
}
