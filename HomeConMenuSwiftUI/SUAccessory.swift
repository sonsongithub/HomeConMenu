//
//  SUAccessory.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/30.
//

import Foundation

class SUAccessory: ObservableObject, Identifiable {
    let id = UUID()
    
    
    @Published var name: String
    @Published var charateristics: [SUCharateristic] = []
    
    let uniqueIdentifier: UUID
    
    init(name: String, uniqueIdentifier: UUID) {
        self.name = name
        self.uniqueIdentifier = uniqueIdentifier
    }
}
