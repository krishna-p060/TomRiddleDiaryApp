//
//  SettingsView.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 19/06/25.
//

import SwiftUI

struct SettingsView: View {
    @ObservedObject var viewModel: DiaryViewModel
    @StateObject private var purchaseManager = PurchaseManager()
    
    
    var body: some View {
        NavigationView {
            List {
                // Section 1: Text Size
                Section("Display Settings") {
                                    VStack(alignment: .leading, spacing: 10) {
                                        Text("Response Text Size")
                                            .font(.handwritten(size: 18))
                                        
                                        Slider(
                                            value: $viewModel.responseTextSize,  // Bind directly to viewModel
                                            in: 16...50,
                                            step: 2
                                        ) { _ in
                                            // Save when user finishes dragging
                                            viewModel.updateTextSize(viewModel.responseTextSize)
                                        }
                                        
                                        HStack {
                                            Text("Size: \(Int(viewModel.responseTextSize))")
                                                .foregroundColor(.gray)
                                            Spacer()
                                            // Preview text
                                            Text("Preview")
                                                .font(.handwritten(size: viewModel.responseTextSize))
                                                .foregroundColor(Color(red: 0.1, green: 0.3, blue: 0.1))
                                        }
                                    }
                                    .padding(.vertical, 5)
                }
                
                // Section 2: Prompt Editing (Premium)
                Section("Advanced Settings") {
                    if purchaseManager.hasPremiumAccess {
                        // Show prompt editing
                        NavigationLink("Edit Tom's Personality") {
                            PromptEditorView(viewModel: viewModel)
                        }
                    } else {
                        // Show paywall
                        Button("🔒 Unlock Advanced Features") {
                            purchaseManager.showPaywall = true
                        }
                        .foregroundColor(.blue)
                    }
                }
                
                // Section 3: Other Settings (if needed)
                Section("About") {
                    Text("Tom Riddle's Diary v1.0")
                        .foregroundColor(.gray)
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $purchaseManager.showPaywall) {
                PaywallView(purchaseManager: purchaseManager)
            }
        }
    }
}
