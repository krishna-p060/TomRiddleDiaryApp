//
//  DiaryPageView.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 16/06/25.
//

import SwiftUI

struct DiaryPageView: View {
    @StateObject private var viewModel = DiaryViewModel()
    @State private var showingResponse = false
    
    var body: some View {
        ZStack {
            // Aged paper background with subtle texture
            backgroundView
            
            // Main content
            VStack(spacing: 0) {
                if showingResponse {
                    // Tom Riddle's response area
                    
                    responseView
                        .transition(.opacity.combined(with: .scale))
                } else {
                    // User writing area
                    writingView
                        .transition(.opacity.combined(with: .scale))
                }
            }
        }
//        .animation(.easeInOut(duration: 0.5), value: showingResponse)
        .onReceive(viewModel.$currentResponse) { response in
            print("DEBUG: DiaryPageView received response: '\(response)'")
            showingResponse = !response.isEmpty
            print("DEBUG: showingResponse set to: \(showingResponse)")
        }
        .onReceive(viewModel.$isCleared) { isCleared in
            if isCleared {
                showingResponse = false
            }
        }
    }
    
    
    private var backgroundView: some View {
        ZStack {
            // Base aged paper color - warmer, more yellowed
            Color(red: 0.94, green: 0.89, blue: 0.76)
            
            // Multiple gradient layers for realistic aging
            
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
            
            // Corner aging - darker edges
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
            
            // Subtle stains and discoloration
            Circle()
                .fill(Color.brown.opacity(0.04))
                .frame(width: 150, height: 100)
                .offset(x: -100, y: -200)
            
            Circle()
                .fill(Color.yellow.opacity(0.06))
                .frame(width: 200, height: 120)
                .offset(x: 120, y: 180)
            
            Circle()
                .fill(Color.brown.opacity(0.03))
                .frame(width: 80, height: 60)
                .offset(x: -150, y: 100)
            
            // Very subtle overall texture
            Rectangle()
                .fill(
                    LinearGradient(
                        colors: [
                            Color.black.opacity(0.01),
                            Color.clear,
                            Color.brown.opacity(0.02),
                            Color.clear,
                            Color.black.opacity(0.01)
                        ],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        }
        .ignoresSafeArea(.all)
    }
    
    private var writingView: some View {
        VStack {
            // Invisible writing hint
            if viewModel.userInput.isEmpty && !viewModel.isProcessing {
                VStack {
                    Image(systemName: "pencil.tip")
                        .font(.system(size: 40))
                        .foregroundColor(.gray.opacity(0.3))
                        .padding(.bottom, 10)
                    
                    Text("Write with your Apple Pencil...")
                        .font(.handwritten(size: 20))
                        .foregroundColor(.gray.opacity(0.5))
                        .multilineTextAlignment(.center)
                }
                .padding()
                .transition(.opacity)
            }
            
            Spacer()
            
            // INVISIBLE Scribble text input area - User won't see their writing!
            ScribbleTextView(
                text: $viewModel.userInput,
                isProcessing: $viewModel.isProcessing,
                onTextRecognized: { recognizedText in
                    print("DEBUG: Text recognized in DiaryPageView: \(recognizedText)")
                    viewModel.processUserInput(recognizedText)
                }
            )
            .background(Color.clear)
            
            Spacer()
            
            // Processing indicator
            if viewModel.isProcessing {
                HStack {
                    ProgressView()
                        .scaleEffect(0.8)
                        .tint(Color(red: 0.1, green: 0.3, blue: 0.1))
                    Text("Tom Riddle is writing...")
                        .font(.handwritten(size: 16))
                        .foregroundColor(.gray)
                }
                .padding()
                .transition(.opacity)
            }
        }
        .padding(40)
    }
    
    private var responseView: some View {
        VStack {
            
            Spacer()
            
            // Tom Riddle's handwritten response
            StreamingTextView(
                text: viewModel.currentResponse,
                font: .handwritten(size: 36),
                color: Color(red: 0.1, green: 0.3, blue: 0.1), // Dark green ink
                typingSpeed: 0.12 // Slightly slower for handwriting effect
            )
            .padding(40)
            .multilineTextAlignment(.leading)
            
            Spacer()
            
            // Tap to continue hint
            HStack {
                Image(systemName: "hand.tap")
                    .font(.system(size: 16))
                Text("Touch anywhere to write again...")
            }
            .font(.handwritten(size: 16))
            .foregroundColor(.gray.opacity(0.7))
            .padding(.bottom, 40)
            .transition(.opacity)
        }
        .contentShape(Rectangle())
        .onTapGesture {
            print("DEBUG: Screen tapped - clearing for new input")
            viewModel.clearForNewInput()
        }
    }
}

#Preview {
    DiaryPageView()
}
