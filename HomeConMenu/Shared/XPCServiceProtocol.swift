//
//  XPCServiceProtocol.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/09/24.
//

import Foundation

// Declare the XPC Service's label in file included in both the main app and XPC service
let xpcServiceLabel = "com.example.XPCService"


// A protocol declaring the exposed methods of the XPC service
@objc protocol XPCServiceProtocol
  {

    func startTimer() -> Void

    func cancelTimer() -> Void

  }


// A protocol declaring the exposed methods of the client application
@objc protocol ClientProtocol
  {

    func incrementCount() -> Void

  }
