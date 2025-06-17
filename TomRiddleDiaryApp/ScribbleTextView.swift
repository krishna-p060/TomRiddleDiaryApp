//
//  ScribbleTextView.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 16/06/25.
//

import SwiftUI
import UIKit

struct ScribbleTextView: UIViewRepresentable {
    @Binding var text: String
    @Binding var isProcessing: Bool
    let onTextRecognized: (String) -> Void
    
    func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        
        // Configure for Scribble handwriting input
        textView.backgroundColor = UIColor.clear
        textView.font = UIFont(name: "Noteworthy-Regular", size: 28) ?? UIFont.systemFont(ofSize: 28)
        textView.textColor = UIColor(red: 0.2, green: 0.1, blue: 0.1, alpha: 1.0) // Dark brown ink
        textView.textContainerInset = UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20)
        textView.isScrollEnabled = true
        textView.showsVerticalScrollIndicator = false
        textView.showsHorizontalScrollIndicator = false
        textView.textContainer.lineFragmentPadding = 0
        
        // Enable Scribble
        let scribbleInteraction = UIScribbleInteraction(delegate: context.coordinator)
        textView.addInteraction(scribbleInteraction)
        textView.delegate = context.coordinator
        
        return textView
    }
    
    func updateUIView(_ uiView: UITextView, context: Context) {
        // Update text if needed
//        if uiView.text != text {
//            uiView.text = text
//        }
        
        // Disable interaction while processing
        uiView.isUserInteractionEnabled = !isProcessing
        
        // Clear text when needed
        if text.isEmpty {
            uiView.text = ""
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UITextViewDelegate, UIScribbleInteractionDelegate {
        let parent: ScribbleTextView
        
        init(_ parent: ScribbleTextView) {
            self.parent = parent
        }
        
        // MARK: - UIScribbleInteractionDelegate
        func scribbleInteraction(_ interaction: UIScribbleInteraction, shouldBeginAt location: CGPoint) -> Bool {
            print("DEBUG: Scribble shouldBegin - processing: \(parent.isProcessing)")
            return !parent.isProcessing
        }
        
        func scribbleInteractionWillBeginWriting(_ interaction: UIScribbleInteraction) {
            print("DEBUG: Scribble will begin writing")
        }
        
        func scribbleInteractionDidFinishWriting(_ interaction: UIScribbleInteraction) {
            print("DEBUG: Scribble finished writing")
            
            // Add delay to let Scribble complete
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                guard let textView = interaction.view as? UITextView else { return }
                
                let recognizedText = textView.text ?? ""
                print("DEBUG: Final recognized text: '\(recognizedText)'")
                
                if !recognizedText.isEmpty {
                    // Clear text view
                    textView.text = ""
                    // Send to parent
                    self.parent.onTextRecognized(recognizedText)
                }
            }
        }
        
        // MARK: - UITextViewDelegate
        func textViewDidChange(_ textView: UITextView) {
            print("DEBUG: Text view changed: '\(textView.text ?? "")'")
            parent.text = textView.text
        }
        
        func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            print("DEBUG: Text view should begin editing")
            return !parent.isProcessing
        }
    }
}
