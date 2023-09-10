//
//  WebViewController.swift
//  HomeConMenu
//
//  Created by Yuichi Yoshida on 2023/09/09.
//

import Foundation
import WebKit

class WebViewController: UIViewController {
    
    private let fileURL: URL
    let webView = WKWebView()
    
    
    // MARK: Lifecycle
    
    init(fileURL: URL) {
        self.fileURL = fileURL
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(webView)
        
        self.view.translatesAutoresizingMaskIntoConstraints = false
        self.webView.translatesAutoresizingMaskIntoConstraints = false
        
        self.webView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        self.webView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        self.webView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        self.webView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        webView.loadFileURL(fileURL, allowingReadAccessTo: fileURL)
    }
    
    
    static func windowScenesIncludingThisClass() -> [UIWindowScene] {
        let candidateWindowScenes = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .filter({ $0.windows.count > 0 })
        let targetWindowScenes = candidateWindowScenes.filter({
            var flag = false
            $0.windows.forEach { window in
                if window.rootViewController is WebViewController {
                    flag = true
                }
            }
            return flag
        })
        return targetWindowScenes
    }
}
