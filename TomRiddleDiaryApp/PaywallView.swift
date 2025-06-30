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
        NavigationView {
            VStack(spacing: 25) {
                Spacer()
                
                // Header
                Text("🔮 Unlock Premium")
                    .font(.handwritten(size: 32))
                    .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.1))
                
                // Features
                VStack(alignment: .leading, spacing: 12) {
                    FeatureRow(icon: "wand.and.stars", text: "Customize Tom's personality")
                    FeatureRow(icon: "text.cursor", text: "Edit response instructions")
                    FeatureRow(icon: "crown", text: "Unlimited advanced features")
                }
                .padding(.horizontal)
                
                Spacer()
                
                // Purchase Button
                if purchaseManager.isLoading {
                    ProgressView("Processing...")
                        .scaleEffect(1.2)
                } else {
                    Button(action: {
                        Task {
                            await purchaseManager.purchasePremium()
                        }
                    }) {
                        Text("Purchase")
                            .font(.handwritten(size: 20))
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(red: 0.1, green: 0.3, blue: 0.1))
                            )
                    }
                    .padding(.horizontal)
                }
                
                // Restore Button
                Button("Restore Purchases") {
                    Task {
                        await purchaseManager.restorePurchases()
                    }
                }
                .font(.handwritten(size: 16))
                .foregroundColor(.blue)
                
                // Error Message
                if let error = purchaseManager.errorMessage {
                    Text(error)
                        .foregroundColor(.red)
                        .font(.caption)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal)
                }
                
                Spacer()
            }
            .navigationTitle("Premium Features")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        presentationMode.wrappedValue.dismiss()
                    }
                }
            }
        }
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.1))
                .frame(width: 24)
            Text(text)
                .font(.handwritten(size: 16))
            Spacer()
        }
    }
}
