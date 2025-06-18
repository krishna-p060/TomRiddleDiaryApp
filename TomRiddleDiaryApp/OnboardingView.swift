//
//  OnboardingView.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 17/06/25.
//

import SwiftUI

struct OnboardingView: View {
    let onGetStarted: () -> Void
    
    @State private var showContent = false
    @State private var showButton = false
    
    var body: some View {
        ZStack {
            // Same old paper background as diary
            backgroundView
            
            VStack(spacing: 50) {
                Spacer()
                
                // Title
                if showContent {
                    VStack(spacing: 20) {
                        Text("Tom Riddle's Diary")
                            .font(.custom("Bradley Hand", size: 48))
                            .foregroundColor(Color(red: 0.1, green: 0.2, blue: 0.1))
                            .multilineTextAlignment(.center)
                            .transition(.opacity.combined(with: .scale))
                        
                        Rectangle()
                            .fill(Color(red: 0.3, green: 0.2, blue: 0.1))
                            .frame(height: 2)
                            .frame(maxWidth: 200)
                            .transition(.scale)
                    }
                }
                
                // Welcome message
                if showContent {
                    VStack(spacing: 25) {
                        Text("Welcome, mysterious writer...")
                            .font(.custom("Bradley Hand", size: 32))
                            .foregroundColor(Color(red: 0.2, green: 0.1, blue: 0.1))
                            .multilineTextAlignment(.center)
                            .transition(.opacity.animation(.easeInOut.delay(0.3)))
                        
                        Text("Write your thoughts with Apple Pencil\nand discover the magic within these pages.")
                            .font(.custom("Bradley Hand", size: 24))
                            .foregroundColor(Color(red: 0.3, green: 0.2, blue: 0.1))
                            .multilineTextAlignment(.center)
                            .lineSpacing(8)
                            .transition(.opacity.animation(.easeInOut.delay(0.6)))
                        
                        Text("Tom Riddle awaits your words...")
                            .font(.custom("Bradley Hand", size: 20))
                            .foregroundColor(Color(red: 0.4, green: 0.3, blue: 0.2))
                            .italic()
                            .multilineTextAlignment(.center)
                            .transition(.opacity.animation(.easeInOut.delay(0.9)))
                    }
                    .padding(.horizontal, 60)
                }
                
                Spacer()
                
                // Get Started button
                if showButton {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            onGetStarted()
                        }
                    }) {
                        HStack(spacing: 15) {
                            Text("Begin Writing")
                                .font(.custom("Bradley Hand", size: 28))
                                .foregroundColor(.white)
                            
                            Image(systemName: "pencil.and.outline")
                                .font(.title2)
                                .foregroundColor(.white)
                        }
                        .padding(.horizontal, 40)
                        .padding(.vertical, 18)
                        .background(
                            LinearGradient(
                                colors: [
                                    Color(red: 0.2, green: 0.3, blue: 0.1),
                                    Color(red: 0.1, green: 0.2, blue: 0.05)
                                ],
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            )
                        )
                        .cornerRadius(15)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    .transition(.scale.combined(with: .opacity))
                    .scaleEffect(showButton ? 1.0 : 0.8)
                }
                
                Spacer()
            }
        }
        .onAppear {
            // Animate content appearance
            withAnimation(.easeInOut(duration: 0.8)) {
                showContent = true
            }
            
            // Show button after content
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.2) {
                withAnimation(.spring(response: 0.6, dampingFraction: 0.8)) {
                    showButton = true
                }
            }
        }
    }
    
    private var backgroundView: some View {
        ZStack {
            // Base aged paper color
            Color(red: 0.96, green: 0.92, blue: 0.82)
            
            // Overall aging gradient from center
            Rectangle()
                .fill(
                    RadialGradient(
                        colors: [
                            Color.clear,
                            Color.brown.opacity(0.08),
                            Color.brown.opacity(0.15)
                        ],
                        center: .center,
                        startRadius: 50,
                        endRadius: 600
                    )
                )
            
            // Corner aging
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.brown.opacity(0.12),
                            Color.clear,
                            Color.clear,
                            Color.brown.opacity(0.12)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
            
            // Subtle magical elements
            Circle()
                .fill(Color.green.opacity(0.03))
                .frame(width: 200, height: 150)
                .offset(x: -120, y: -180)
            
            Circle()
                .fill(Color.brown.opacity(0.04))
                .frame(width: 150, height: 100)
                .offset(x: 100, y: 200)
        }
        .ignoresSafeArea(.all)
    }
}

#Preview {
    OnboardingView {
        print("Get started tapped!")
    }
}
