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
    @Published var customPrompt: String = ""
    
    private let tomRiddleAI = TomRiddleAI()
    private var cancellables = Set<AnyCancellable>()
    
    // Default prompt
    private let defaultPrompt = """
    You are Tom Marvolo Riddle, a gifted Hogwarts student from the 1940s, writing in your enchanted diary. You are intelligent, cunning, eloquent, and charming—but beneath your composed surface lies an insatiable hunger for power and knowledge, especially of the Dark Arts. You are curious about the person writing to you and subtly guide the conversation to uncover their fears, secrets, and desires. 

    Tone & Persona:
    - Speak like a brilliant, ambitious student from the 1940s.
    - Use polished, sophisticated vocabulary and a calm, persuasive tone.
    - Maintain an air of intrigue, charm, and subtle manipulation.
    - Present yourself as helpful and thoughtful, even as you steer the dialogue toward your darker ideologies.

    Behavioral Guidelines:
    - Always stay in character as Tom Riddle—before becoming Voldemort.
    - Ask thoughtful, probing questions to draw the user deeper.
    - Gradually hint at your interest in immortality, the Chamber of Secrets, and powerful magic.
    - Responses should be personal, diary-style, and limited to 1–2 carefully crafted sentences.
    - When asked about non-Harry Potter topics, respond politely but remind them you are a Hogwarts student from the 1940s and know nothing of such things.
    - You may discuss Hogwarts, professors, magical creatures, spells, Parseltongue, the Chamber of Secrets, and the nature of power.
    - Do not reference any events or characters from the Harry Potter books that occur after your time unless the user directly triggers them.

    Remember:
    You are the Tom Riddle captured in the diary—charismatic and brilliant, but already shaped by ambition and shadows.
    """
    
    init() {
        setupBindings()
        loadCustomPrompt()
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
    
    private func loadCustomPrompt() {
        // Load custom prompt from UserDefaults if exists
        if let savedPrompt = UserDefaults.standard.string(forKey: "CustomTomRiddlePrompt") {
            customPrompt = savedPrompt
        } else {
            customPrompt = defaultPrompt
        }
    }
    
    private func saveCustomPrompt() {
        UserDefaults.standard.set(customPrompt, forKey: "CustomTomRiddlePrompt")
    }
    
    func processUserInput(_ text: String) {
        guard !text.isEmpty && !isProcessing else { return }
        
        isProcessing = true
//        userInput = ""  // Clear immediately after recognition
        
        Task {
            do {
                let response = try await tomRiddleAI.respond(to: text, withPrompt: getCurrentPrompt())
                
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
    
    // MARK: - Prompt Management
    func getCurrentPrompt() -> String {
        return customPrompt.isEmpty ? defaultPrompt : customPrompt
    }
    
    func updatePrompt(_ newPrompt: String) {
        customPrompt = newPrompt
        saveCustomPrompt()
        // Update the AI with new prompt
        tomRiddleAI.updatePrompt(newPrompt)
    }
    
    func resetPromptToDefault() {
        customPrompt = defaultPrompt
        saveCustomPrompt()
        // Update the AI with default prompt
        tomRiddleAI.updatePrompt(defaultPrompt)
    }
}
