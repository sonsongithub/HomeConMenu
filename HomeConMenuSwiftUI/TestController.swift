//
//  TestController.swift
//  HomeConMenuSwiftUI
//
//  Created by Yuichi Yoshida on 2022/10/09.
//

import Foundation
import os
import AppKit

class TestController {
    
    @objc func fromMacNotification(_ notification: Notification) {
        print("a")
        print(#function)
        let obj = notification.object
        print(obj)
        
        let decoder = JSONDecoder()
        
        guard let stringJson = notification.object as? String else {
            return
        }
        
        guard let data = stringJson.data(using: .utf8) else {
            return
        }
        
        do {
            let obj = try decoder.decode(HCCommunication.self, from: data)
            print(obj)
        } catch {
            print(error)
        }
        
    }
    
    init() {
        print("aaaaa")
        DistributedNotificationCenter.default().addObserver(self, selector: #selector(fromMacNotification), name: .to_macNotification, object: nil)
    }
}
