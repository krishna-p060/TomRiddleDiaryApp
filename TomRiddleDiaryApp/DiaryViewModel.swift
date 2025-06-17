//
//  DiaryViewModel.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 16/06/25.
//

import SwiftUI
import Combine
import FoundationModels

@MainActor
class DiaryViewModel: ObservableObject {
    @Published var userInput: String = ""
    @Published var currentResponse: String = ""
    @Published var isProcessing: Bool = false
    @Published var isCleared: Bool = false
    
    private let tomRiddleAI = TomRiddleAI()
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupBindings()
    }
    
    private func setupBindings() {
        // Reset cleared state when user starts typing
        $userInput
            .dropFirst()
            .sink { [weak self] text in
                if !text.isEmpty {
                    self?.isCleared = false
                }
            }
            .store(in: &cancellables)
    }
    
    func processUserInput(_ text: String) {
        guard !text.isEmpty && !isProcessing else { return }
        
        isProcessing = true
//        userInput = ""  // Clear immediately after recognition
        
        Task {
            do {
                let response = try await tomRiddleAI.respond(to: text)
                
                await MainActor.run {
                    self.isProcessing = false
                    self.currentResponse = response
                    print("DEBUG: Set currentResponse to: \(self.currentResponse)")
                }
            } catch {
                await MainActor.run {
                    self.isProcessing = false
                    self.currentResponse = "The diary seems troubled... Perhaps try writing again?"
                }
            }
        }
    }
    
    func clearForNewInput() {
        currentResponse = ""
        userInput = ""
        isCleared = true
        isProcessing = false
    }
}
