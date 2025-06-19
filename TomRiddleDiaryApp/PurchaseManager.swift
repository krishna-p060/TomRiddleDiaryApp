//
//  PurchaseManager.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 19/06/25.
//

import StoreKit
import Combine

@MainActor
class PurchaseManager: ObservableObject {
    @Published var hasPremiumAccess = false
    @Published var showPaywall = false
    
    private let productID = "com.yourapp.premium_features"
    
    init() {
        checkPremiumStatus()
    }
    
    func checkPremiumStatus() {
        // Check if user has purchased
        hasPremiumAccess = UserDefaults.standard.bool(forKey: "premium_purchased")
    }
    
    func purchasePremium() async {
        do {
            guard let product = try await Product.products(for: [productID]).first else { return }
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Verify and unlock
                hasPremiumAccess = true
                UserDefaults.standard.set(true, forKey: "premium_purchased")
                showPaywall = false
            case .userCancelled:
                break
            case .pending:
                break
            @unknown default:
                break
            }
        } catch {
            print("Purchase failed: \(error)")
        }
    }
    
    func restorePurchases() async {
        // Handle restore purchases
        try? await AppStore.sync()
        checkPremiumStatus()
    }
}
