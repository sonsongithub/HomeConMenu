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
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        webView.frame = CGRect(x: 0, y: 0, width: 300, height: 300)
        let url = Bundle.main.url(forResource: "Acknowledgments", withExtension: "html")!
        webView.loadFileURL(url, allowingReadAccessTo: url)
    }
}
