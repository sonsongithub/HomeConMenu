//
//  HCActionSet.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2022/10/24.
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

struct HCActionSet: Codable {
    public var actionSetName: String
    public let uniqueIdentifier: UUID
    public var actionUniqueIdentifiers: [UUID]
    public var targetValues: [Double] = []
    
#if !os(macOS)
    public init(actionSet: HMActionSet) {
        self.actionSetName = actionSet.name
        self.uniqueIdentifier = actionSet.uniqueIdentifier
        self.actionUniqueIdentifiers = actionSet.actions.compactMap({ $0 as? HMCharacteristicWriteAction<NSCopying> }).map({ $0.characteristic.uniqueIdentifier })
        self.targetValues = actionSet.actions.compactMap({ $0 as? HMCharacteristicWriteAction<NSCopying> }).compactMap({ $0.targetValue as? Double })
    }
#endif
}
