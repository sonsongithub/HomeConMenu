//
//  DonationPaneController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/10/08.
//

import AppKit
import StoreKit

class DonationPaneController: NSViewController {
    
    @IBOutlet var stackView: NSStackView?
    @IBOutlet var indicator: NSProgressIndicator?
    
    var products: [Product] = []
    
    func update() {
        
        // create
        (0..<5).forEach { _ in
            let v = DonationItemView()
            v.wantsLayer = true
            v.layer?.backgroundColor = NSColor.red.cgColor
            v.translatesAutoresizingMaskIntoConstraints = false
            v.widthAnchor.constraint(equalToConstant: 300).isActive = true
            v.heightAnchor.constraint(equalToConstant: 20).isActive = true
            stackView?.addArrangedSubview(v)
        }
        
        // load from nib
        // when following codes are commented out, this view will be rendered correctly.
        let nib = NSNib(nibNamed: "DonationPane", bundle: nil)
        (0..<5).forEach { product in
            var topLevelArray: NSArray? = nil
            nib?.instantiate(withOwner: self, topLevelObjects: &topLevelArray)
            if let topLevelArray = topLevelArray {
                let a = topLevelArray.compactMap { element in
                    return element as? DonationItemView
                }
                if let donationView = a.first {
                    donationView.label?.stringValue = "test"
                    
                    donationView.translatesAutoresizingMaskIntoConstraints = false
                    donationView.widthAnchor.constraint(equalToConstant: 300).isActive = true
                    donationView.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    stackView?.addArrangedSubview(donationView)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.update()
    }
    
}
