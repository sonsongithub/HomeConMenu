//
//  SUClimate.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/30.
//

import Foundation

class SUClimate: ObservableObject, Identifiable {
    let id = UUID()
    
    @Published var name: String
    @Published var value: Double
    
    let uniqueIdentifier: UUID
    
    init(name: String, uniqueIdentifier: UUID) {
        self.name = name
        value = 0
        self.uniqueIdentifier = uniqueIdentifier
    }
}
