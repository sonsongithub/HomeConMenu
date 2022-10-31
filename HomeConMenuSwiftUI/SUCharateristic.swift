//
//  SUCharateristic.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/30.
//

import Foundation

class SUCharateristic: ObservableObject, Identifiable {
    let id = UUID()
    
    @Published var name: String
    
    let uniqueIdentifier: UUID
    
    init(name: String, uniqueIdentifier: UUID) {
        self.name = name
        self.uniqueIdentifier = uniqueIdentifier
    }
}
