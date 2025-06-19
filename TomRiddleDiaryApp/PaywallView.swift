//
//  PaywallView.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 19/06/25.
//

import SwiftUI

struct PaywallView: View {
    @ObservedObject var purchaseManager: PurchaseManager
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack(spacing: 20) {
            Text("🔮 Unlock Advanced Features")
                .font(.handwritten(size: 28))
            
            Text("Customize Tom Riddle's personality and responses")
                .multilineTextAlignment(.center)
            
            Button("Purchase - $2.99") {
                Task {
                    await purchaseManager.purchasePremium()
                }
            }
            .buttonStyle(.borderedProminent)
            
            Button("Restore Purchases") {
                Task {
                    await purchaseManager.restorePurchases()
                }
            }
            
            Button("Cancel") {
                presentationMode.wrappedValue.dismiss()
            }
        }
        .padding()
    }
}
