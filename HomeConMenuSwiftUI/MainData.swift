//
//  MainData.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/29.
//

import SwiftUI

class MainData: ObservableObject {
    @Published var rooms: [HCRoom] = []
    @Published var accesories: [HCAccessory] = []
    
    init() {
        accesories = []
    }
}
