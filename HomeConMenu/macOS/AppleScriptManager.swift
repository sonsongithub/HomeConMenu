//
//  AppleScriptManager.swift
//  MusicConMenu
//
//  Created by Yuichi Yoshida on 2024/11/05.
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

import Cocoa
import Foundation

protocol CreatableFromNSAppleEventDescriptor {
    static func get(a:NSAppleEventDescriptor) throws -> Self
}

extension Int : CreatableFromNSAppleEventDescriptor {
    static func get(a:NSAppleEventDescriptor) throws -> Self {
        return Int(a.int32Value)
    }
}

extension String : CreatableFromNSAppleEventDescriptor {
    static func get(a:NSAppleEventDescriptor) throws -> Self {
        guard let string = a.stringValue else {
            throw AppleScriptManagerError.canNotGetString
        }
        return string
    }
}

enum AppleScriptManagerError: Error {
    case appleScriptError
    case appleScriptExecutionError(Dictionary<String, Any>)
    case canNotGetString
}

class AppleScriptManager {
    
    static func call(script: String) throws -> NSAppleEventDescriptor {
        var error: NSDictionary?
        guard let scriptObject = NSAppleScript(source: script) else {
            throw AppleScriptManagerError.appleScriptError
        }
        let output = scriptObject.executeAndReturnError(&error)
        if let error {
            var dicitonary: [String: Any] = [:]
            for key in error.allKeys {
                if let key = key as? String {
                    dicitonary[key] = error[key]
                }
            }
            throw AppleScriptManagerError.appleScriptExecutionError(dicitonary)
        }
        return output
    }
    
    static func execute<A: CreatableFromNSAppleEventDescriptor>(script: String) throws -> A {
        let output = try call(script: script)
        return try A.get(a: output)
    }
    
    static func execute<A: CreatableFromNSAppleEventDescriptor>(script: String) throws -> [A] {
        let output = try call(script: script)
        var array: [A] = []
        for i in 0..<output.numberOfItems {
            if let obj = output.atIndex(i) {
                array.append(try A.get(a: obj))
            }
        }
        return array
    }
}
