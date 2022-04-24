//
//  AccessoryInfo.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/08.
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

@objc(AccessoryInfoProtocol)
public protocol AccessoryInfoProtocol: NSObjectProtocol {
    init()
    var home: HomeInfoProtocol? { get set }
    var room: RoomInfoProtocol? { get set }
    
    var name: String? { get set }
    var uniqueIdentifier: UUID { get set }
    
    var hasCamera: Bool { get set }
    
    var services: [ServiceInfoProtocol] { get set }
    
    var type: AccessoryType { get set }
}

public class AccessoryInfo: NSObject, AccessoryInfoProtocol {
    public var home: HomeInfoProtocol?
    public var room: RoomInfoProtocol?
    
    public var name: String?
    public var uniqueIdentifier: UUID = UUID()
    
    public var services: [ServiceInfoProtocol] = []
    
    public var type: AccessoryType = .unknown
    
    public var hasCamera: Bool = false
    
    required public override init() {
    }
}
