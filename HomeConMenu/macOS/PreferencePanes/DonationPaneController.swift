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
    
    func update() {
        
        guard let stackView = self.stackView else { return }
        
        stackView.alignment = .centerX
        
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
                    donationView.label?.stringValue = String(format: NSLocalizedString("Offer %@", comment: ""), product.displayName)
                    donationView.translatesAutoresizingMaskIntoConstraints = false
                    donationView.widthAnchor.constraint(equalToConstant: 560).isActive = true
                    donationView.heightAnchor.constraint(equalToConstant: 70).isActive = true
                    donationView.icon?.stringValue = product.description
                    donationView.donate?.title = product.displayPrice
                    donationView.donate?.identifier = NSUserInterfaceItemIdentifier(product.id)
                    donationView.donate?.action = #selector(DonationPaneController.didPushDonationButton(sender:))
                    donationView.donate?.target = self
                    stackView.addArrangedSubview(donationView)
                }
            }
        }
    }
    
    @objc func didPushDonationButton(sender: NSButton) {
        guard let product = self.products.first(where: { $0.id == sender.identifier?.rawValue}) else { return }
        
        Task {
            do {
                let result = try await product.purchase()
                switch result {
                case let .success(.verified(transaction)):
                    await transaction.finish()
                case let .success(.unverified(_, error)):
                    Logger.app.info("\(error.localizedDescription)")
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
                
                self.update()
                self.indicator?.stopAnimation(nil)
                self.indicator?.isHidden = true
                self.errorMessage?.isHidden = true
            } catch {
                Logger.app.error("Failed product request from the App Store server: \(error)")
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
