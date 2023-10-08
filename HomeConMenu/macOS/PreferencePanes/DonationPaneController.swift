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
        let nib = NSNib(nibNamed: "DonationPane", bundle: nil)
        self.products.forEach { product in
            
            var topLevelArray: NSArray? = nil
            nib?.instantiate(withOwner: self, topLevelObjects: &topLevelArray)
            if let topLevelArray = topLevelArray {
                let a = topLevelArray.compactMap { element in
                    return element as? DonationItemView
                }
                if let donationView = a.first {
                    donationView.label?.stringValue = product.id
                    
                    donationView.translatesAutoresizingMaskIntoConstraints = false
                    donationView.widthAnchor.constraint(equalToConstant: 300).isActive = true
                    donationView.heightAnchor.constraint(equalToConstant: 60).isActive = true
                    
                    self.view.addSubview(donationView)
                    print(donationView)
                }
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        indicator?.startAnimation(nil)
        
        Task {
            do {
//                try await Task.sleep(nanoseconds: 3_000_000_000)
                let keys = ["com.sonson.HomeConMenu.macOS.test_item", "com.sonson.HomeConMenu.macOS.test_item2"]
                let storeProducts = try await Product.products(for: keys)
                for product in storeProducts {
                    switch product.type {
                    case .consumable:
                        self.products.append(product)
                    default:
                        print("Unknown product")
                    }
                }
                self.update()
                self.indicator?.stopAnimation(nil)
            } catch {
                print("Failed product request from the App Store server: \(error)")
            }
        }
//        (0..<10).forEach { _ in
//            let v = DonationItemView()
//            v.wantsLayer = true
//            v.layer?.backgroundColor = NSColor.red.cgColor
//            v.translatesAutoresizingMaskIntoConstraints = false
//            v.widthAnchor.constraint(equalToConstant: 300).isActive = true
//            v.heightAnchor.constraint(equalToConstant: 20).isActive = true
//            stackView?.addArrangedSubview(v)
//        }
    }
    
}
