//
//  StreamingTextView.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 16/06/25.
//

import SwiftUI

struct StreamingTextView: View {
    let text: String
    let font: Font
    let color: Color
    let typingSpeed: Double
    
    @State private var displayedText: String = ""
    @State private var currentIndex: Int = 0
    @State private var handwritingOffset: CGSize = .zero
    @State private var showCursor: Bool = false
    @State private var animationTimer: Timer?
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            // Debug text (remove this later)
//            Text("DEBUG: StreamingTextView loaded with: \(text.prefix(20))...")
//                .foregroundColor(.blue)
//                .font(.caption)
            
            Text(displayedText)
                .font(font)
                .foregroundColor(color)
                .multilineTextAlignment(.leading)
                .frame(maxWidth: .infinity, alignment: .leading)
                .offset(handwritingOffset)
                .animation(.easeInOut(duration: 0.1), value: handwritingOffset)
            
            // Animated cursor/pen effect
            if showCursor && currentIndex < text.count {
                Circle()
                    .fill(color.opacity(0.6))
                    .frame(width: 3, height: 3)
                    .offset(x: getCursorPosition().x, y: getCursorPosition().y)
                    .animation(.easeInOut(duration: 0.1), value: currentIndex)
            }
        }
        .onAppear {
            print("DEBUG: StreamingTextView onAppear with text: '\(text.prefix(20))...'")
            if !text.isEmpty {
                startHandwritingAnimation(for: text)
            }
        }
        .onChange(of: text) { newText in
            print("DEBUG: StreamingTextView text changed to: '\(newText.prefix(20))...'")
            startHandwritingAnimation(for: newText)
        }
    }
    
    private func startHandwritingAnimation(for newText: String) {
        print("DEBUG: StreamingTextView starting animation for: '\(newText.prefix(20))...'")
        
        // Stop any existing timer
        animationTimer?.invalidate()
        
        // Reset animation state
        displayedText = ""
        currentIndex = 0
        showCursor = true
        
        guard !newText.isEmpty else { return }
        
        print("DEBUG: Starting timer with speed: \(typingSpeed)")
        
        // Start handwriting animation with slight variations
        animationTimer = Timer.scheduledTimer(withTimeInterval: typingSpeed, repeats: true) { timer in
            print("DEBUG: Timer tick - currentIndex: \(self.currentIndex), textLength: \(newText.count)")
            
            if currentIndex < newText.count {
                let endIndex = newText.index(newText.startIndex, offsetBy: currentIndex + 1)
                displayedText = String(newText[..<endIndex])
                
                // Add slight handwriting variations
                addHandwritingVariation()
                
                currentIndex += 1
            } else {
                print("DEBUG: Animation completed, stopping timer")
                timer.invalidate()
                animationTimer = nil
                showCursor = false
            }
        }
    }
    
    private func addHandwritingVariation() {
        // Add more realistic handwriting variations
        let randomX = Double.random(in: -1.0...1.0)
        let randomY = Double.random(in: -0.8...0.8)
        let randomRotation = Double.random(in: -2...2) // degrees
        
        handwritingOffset = CGSize(width: randomX, height: randomY)
        
        // Add slight rotation variation per character
        withAnimation(.easeInOut(duration: 0.05)) {
            handwritingOffset = CGSize(width: randomX, height: randomY)
        }
    }
    
    private func getCursorPosition() -> CGPoint {
        // Approximate cursor position (simplified)
        let lineHeight: CGFloat = 30
        let charWidth: CGFloat = 12
        
        let lines = displayedText.components(separatedBy: .newlines)
        let currentLine = lines.count - 1
        let currentLineLength = lines.last?.count ?? 0
        
        return CGPoint(
            x: CGFloat(currentLineLength) * charWidth,
            y: CGFloat(currentLine) * lineHeight
        )
    }
}

// MARK: - Handwritten Font Extension
extension Font {
    static var handwritten: Font {
        // Use a more handwritten-looking font with fallbacks
        return .custom("Bradley Hand", size: 24) ??
               .custom("Chalkduster", size: 24) ??
               .custom("Marker Felt", size: 24) ??
               .custom("Noteworthy-Regular", size: 24)
    }
    
    static func handwritten(size: CGFloat) -> Font {
        // Try multiple handwriting fonts in order of preference
        if let bradleyHand = UIFont(name: "Bradley Hand", size: size) {
            return .custom("Bradley Hand", size: size)
        } else if let chalkduster = UIFont(name: "Chalkduster", size: size) {
            return .custom("Chalkduster", size: size)
        } else if let markerFelt = UIFont(name: "Marker Felt", size: size) {
            return .custom("Marker Felt", size: size)
        } else {
            return .custom("Noteworthy-Regular", size: size)
        }
    }
}

#Preview {
    StreamingTextView(
        text: "Hello, I am Tom Riddle. How fascinating that you can write to me...",
        font: .handwritten,
        color: Color(red: 0.1, green: 0.3, blue: 0.1),
        typingSpeed: 0.08
    )
    .padding()
}
