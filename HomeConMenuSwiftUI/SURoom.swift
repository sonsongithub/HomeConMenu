//
//  SURoom.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/30.
//

import Foundation

class SURoom: ObservableObject, Identifiable {
    let id = UUID()
    
    @Published var accessories: [SUAccessory] = []
    @Published var name: String
    
    init(id: UUID = UUID(), name: String) {
        self.name = name
    }
}
