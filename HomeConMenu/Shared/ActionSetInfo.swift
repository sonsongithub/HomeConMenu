//
//  ActionSetInfo.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/05/06.
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


@objc(ActionSetInfoProtocol)
public protocol ActionSetInfoProtocol: NSObjectProtocol {
    init()
    var name: String { get set }
    var uniqueIdentifier: UUID { get set }
    var actionUniqueIdentifiers: [UUID] { get set }
}

public class ActionSetInfo: NSObject, ActionSetInfoProtocol {
    public var name: String
    public var uniqueIdentifier: UUID
    public var actionUniqueIdentifiers: [UUID]
    
#if !os(macOS)
    public init(actionSet: HMActionSet) {
        self.name = actionSet.name
        self.uniqueIdentifier = actionSet.uniqueIdentifier
        self.actionUniqueIdentifiers = actionSet.actions.compactMap({ $0 as? HMCharacteristicWriteAction<NSCopying> }).map({ $0.characteristic.uniqueIdentifier })
        super.init()
    }
#endif
    
    required public override init() {
        fatalError()
    }
}
