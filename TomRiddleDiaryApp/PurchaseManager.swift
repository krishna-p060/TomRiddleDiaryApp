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
    @Published var isLoading = false
    @Published var errorMessage: String?
    
    private let productID = "com.krishna.premium_access" // Match App Store Connect
    private var product: Product?
    
    init() {
        checkPremiumStatus()
        loadProducts()
    }
    
    // MARK: - Load Products from App Store
    private func loadProducts() {
        Task {
            do {
                let products = try await Product.products(for: [productID])
                if let product = products.first {
                    self.product = product
                    print("✅ Product loaded: \(product.displayName) - \(product.displayPrice)")
                } else {
                    print("❌ No products found - check App Store Connect configuration")
                }
            } catch {
                print("❌ Failed to load products: \(error)")
                errorMessage = "Failed to load products"
            }
        }
    }
    
    // MARK: - Purchase Logic
    func purchasePremium() async {
        guard let product = product else {
            errorMessage = "Product not available"
            return
        }
        
        isLoading = true
        errorMessage = nil
        
        do {
            let result = try await product.purchase()
            
            switch result {
            case .success(let verification):
                // Verify the transaction
                let transaction = try checkVerified(verification)
                
                // Transaction is verified, unlock features
                await unlockPremiumFeatures()
                
                // Finish the transaction
                await transaction.finish()
                
                showPaywall = false
                
            case .userCancelled:
                print("User cancelled purchase")
                
            case .pending:
                print("Purchase pending (family sharing approval, etc.)")
                
            @unknown default:
                print("Unknown purchase result")
            }
        } catch {
            print("❌ Purchase failed: \(error)")
            errorMessage = "Purchase failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
    
    // MARK: - Transaction Verification
    private func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw PurchaseError.unverifiedTransaction
        case .verified(let safe):
            return safe
        }
    }
    
    // MARK: - Unlock Features
    private func unlockPremiumFeatures() async {
        hasPremiumAccess = true
        UserDefaults.standard.set(true, forKey: "premium_purchased")
        UserDefaults.standard.set(Date(), forKey: "premium_purchase_date")
        print("✅ Premium features unlocked!")
    }
    
    // MARK: - Check Purchase Status
    func checkPremiumStatus() {
        // Check UserDefaults first (for offline)
        hasPremiumAccess = UserDefaults.standard.bool(forKey: "premium_purchased")
        
        // Verify with App Store
        Task {
            for await result in Transaction.currentEntitlements {
                let transaction = try? checkVerified(result)
                if transaction?.productID == productID {
                    await unlockPremiumFeatures()
                    return
                }
            }
        }
    }
    
    // MARK: - Restore Purchases
    func restorePurchases() async {
        isLoading = true
        
        do {
            try await AppStore.sync()
            
            for await result in Transaction.currentEntitlements {
                let transaction = try? checkVerified(result)
                if transaction?.productID == productID {
                    await unlockPremiumFeatures()
                    return
                }
            }
            
            // No purchases found
            errorMessage = "No previous purchases found"
            
        } catch {
            print("❌ Restore failed: \(error)")
            errorMessage = "Restore failed: \(error.localizedDescription)"
        }
        
        isLoading = false
    }
}

// MARK: - Purchase Errors
enum PurchaseError: Error {
    case unverifiedTransaction
}
