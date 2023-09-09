//
//  WebViewController.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2023/09/09.
//

import Foundation
import WebKit

class WebViewController: UIViewController {
    
    let webView = WKWebView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
    }
}
