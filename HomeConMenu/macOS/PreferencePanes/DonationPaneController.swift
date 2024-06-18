//
//  DonationPaneController.swift
//  macOSBridge
//
//  Created by Yuichi Yoshida on 2023/10/08.
//

import AppKit
import StoreKit
import os

class DonationPaneController: NSViewController {
    
    @IBOutlet var stackView: NSStackView?
    @IBOutlet var indicator: NSProgressIndicator?
    @IBOutlet var errorMessage: NSTextField?
    
    var products: [Product] = []
    
    static func loadProductIdToEmojiData() -> [String: String] {
        guard let path = Bundle.main.path(forResource: "Products", ofType: "plist"),
              let plist = FileManager.default.contents(atPath: path),
              let data = try? PropertyListSerialization.propertyList(from: plist, format: nil) as? [String: String] else {
            return [:]
        }
        return data
    }
    
    func update() {
        
        guard let stackView = self.stackView else { return }
        
        stackView.alignment = .centerX
        
        let data = DonationPaneController.loadProductIdToEmojiData()
        
        // load from nib
        // when following codes are commented out, this view will be rendered correctly.
        let nib = NSNib(nibNamed: "DonationPane", bundle: nil)
        self.products.forEach { product in
            var topLevelArray: NSArray? = nil
            nib?.instantiate(withOwner: nil, topLevelObjects: &topLevelArray)
            if let topLevelArray = topLevelArray {
                let a = topLevelArray.compactMap { element in
                    return element as? DonationItemView
                }
                if let donationView = a.first {
                    donationView.label?.stringValue = product.description
                    donationView.translatesAutoresizingMaskIntoConstraints = false
                    donationView.widthAnchor.constraint(equalToConstant: 560).isActive = true
                    donationView.heightAnchor.constraint(equalToConstant: 70).isActive = true
                    if let str = data[product.id] {
                        donationView.icon?.stringValue = str
                    } else {
                        donationView.icon?.stringValue = "プレゼント"
                    }
                    donationView.donate?.title = product.displayPrice
                    donationView.donate?.identifier = NSUserInterfaceItemIdentifier(product.id)
                    donationView.donate?.action = #selector(DonationPaneController.didPushDonationButton(sender:))
                    donationView.donate?.target = self
                    stackView.addArrangedSubview(donationView)
                }
            }
        }
        
        if self.products.count == 0 {
            errorMessage?.stringValue = NSLocalizedString("No items", comment: "")
            errorMessage?.isHidden = false
        } else {
            errorMessage?.isHidden = true
        }
    }
    
    func showThankyou() {
        let alert = NSAlert()
        alert.messageText = NSLocalizedString("Thank you!", comment: "")
        alert.alertStyle = .informational
        alert.addButton(withTitle: "OK")
        let _ = alert.runModal()
    }
    
    @MainActor
    @objc func didPushDonationButton(sender: NSButton) {
        guard let product = self.products.first(where: { $0.id == sender.identifier?.rawValue}) else { return }
        
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case .success(.verified(_)):
                    self.showThankyou()
                case let .success(.unverified(_, error)):
                    Logger.app.error("\(error.localizedDescription)")
                    self.showThankyou()
                case .pending:
                    let alert = NSAlert()
                    alert.messageText = NSLocalizedString("Error", comment: "")
                    alert.informativeText = NSLocalizedString("Purchase is pending and requires action in the App Store.", comment: "")
                    alert.alertStyle = .informational
                    alert.addButton(withTitle: "OK")
                    let _ = alert.runModal()
                    break
                case .userCancelled:
                    Logger.app.info("userCancelled")
                    break
                default:
                    break
                }
            } catch {
                let alert = NSAlert()
                alert.messageText = NSLocalizedString("Error", comment: "")
                alert.informativeText = "\(error.localizedDescription)"
                alert.alertStyle = .informational
                alert.addButton(withTitle: "OK")
                let _ = alert.runModal()
            }
        }
    }
    
    func didShowOnTabView() {
        
        indicator?.isHidden = false
        self.errorMessage?.isHidden = true
        indicator?.startAnimation(nil)
        self.stackView?.arrangedSubviews.forEach({
            $0.removeFromSuperview()
        })
        self.products.removeAll()
        
        Task {
            do {
                let data = DonationPaneController.loadProductIdToEmojiData()
                let keys = data.keys
                let storeProducts = try await Product.products(for: keys)
                for product in storeProducts {
                    switch product.type {
                    case .consumable:
                        self.products.append(product)
                    default:
                        Logger.app.error("Unknown products are enumerated by StoreKit.")
                    }
                }
                
                // sort by price
                products.sort { lhs, rhs in
                    return lhs.price < rhs.price
                }
                
                self.indicator?.stopAnimation(nil)
                self.indicator?.isHidden = true
                self.update()
            } catch {
                Logger.app.error("App Store Kit error. Failed product request from the App Store server: \(error)")
                let errorMessage = String(format: NSLocalizedString("App Store Error: %@", comment: ""), error.localizedDescription)
                self.errorMessage?.stringValue = errorMessage
                self.errorMessage?.isHidden = false
                self.indicator?.stopAnimation(nil)
                self.indicator?.isHidden = true
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stackView?.spacing = 20
    }
}
