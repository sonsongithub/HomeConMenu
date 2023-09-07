//
//  ViewController.swift
//  HomeMenu
//
//  Created by Yuichi Yoshida on 2022/03/02.
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

import UIKit

class DummyViewController: UIViewController {
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        print("\(self) - \(#function)")
    }
    
    static func windowScenesIncludingThisClass() -> [UIWindowScene] {
        let candidateWindowScenes = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .filter({ $0.windows.count > 0 })
        let targetWindowScenes = candidateWindowScenes.filter({
            var flag = false
            $0.windows.forEach { window in
                if window.rootViewController is DummyViewController {
                    flag = true
                }
            }
            return flag
        })
        return targetWindowScenes
    }
    
    deinit {
        print("\(self) - \(#function)")
    }
    
}

