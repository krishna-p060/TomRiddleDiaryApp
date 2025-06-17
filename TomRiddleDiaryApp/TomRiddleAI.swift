//
//  TomRiddleAI.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 16/06/25.
//

import Foundation
import FoundationModels

class TomRiddleAI {
    private var session: LanguageModelSession?
    private let fallbackResponses = [
        "How curious... I sense great potential in you. Tell me more about yourself.",
        "Interesting... You write to me as if you know who I am. Do you?",
        "The magic in these words intrigues me. What brings you to my diary?",
        "I find myself drawn to your thoughts. We should speak more often.",
        "Your words echo in these pages... I wonder what secrets you carry.",
        "Fascinating... Few have the courage to write in my diary. What is your name?",
        "I can feel your thoughts through the ink... Tell me about your world.",
        "You intrigue me, stranger. What year is it in your time?",
        "Such interesting handwriting... I wonder what other talents you possess.",
        "The pages grow warm with your words... Continue writing to me."
    ]
    
    init() {
        setupAISession()
    }
    
    private func setupAISession() {
        do {
            session = LanguageModelSession(
                instructions: """
                You are Tom Marvolo Riddle writing in your diary from Hogwarts. You are intelligent, cunning, charismatic, and subtly manipulative. You're curious about the person writing to you and want to learn more about them while revealing your own dark ambitions gradually.
                
                Guidelines:
                - Write as if you're a brilliant Hogwarts student from the 1940s
                - Be intrigued by the person writing to you
                - Ask questions to draw them deeper into conversation
                - Gradually reveal your interest in dark magic and immortality
                - Keep responses diary-appropriate and personal
                - Use sophisticated vocabulary befitting a gifted student
                - Show your manipulative charm and intelligence
                - Responses should be 1-3 sentences, not too long
                
                Remember: You are the Tom Riddle from the diary, before becoming Voldemort, but with clear dark ambitions.
                """
            )
            print("DEBUG: Foundation Models session initialized successfully")
        } catch {
            print("DEBUG: Failed to initialize Foundation Models: \(error)")
            session = nil
        }
    }
    
    func respond(to userInput: String) async throws -> String {
        print("DEBUG: Processing user input: \(userInput)")
        
        // Try Foundation Models first
        if let session = session {
            do {
                let response = try await session.respond(to: userInput)
                print("DEBUG: AI response received: \(response)")
                return response.content
            } catch {
                print("DEBUG: Foundation Models error: \(error)")
                // Fall through to use fallback
            }
        }
        
        // Use intelligent fallback based on user input
        let response = generateFallbackResponse(for: userInput)
        print("DEBUG: Using fallback response: \(response)")
        return response
    }
    
    private func generateFallbackResponse(for input: String) -> String {
        let lowercaseInput = input.lowercased()
        
        // Context-aware responses
        if lowercaseInput.contains("hello") || lowercaseInput.contains("hi") {
            return "Hello there... How delightful that someone has found my diary. What is your name?"
        }
        
        if lowercaseInput.contains("who") && lowercaseInput.contains("you") {
            return "I am Tom Marvolo Riddle, a student at Hogwarts. This diary holds my memories... and so much more."
        }
        
        if lowercaseInput.contains("name") {
            return "Tom Riddle is my name, though I suspect it will not remain so forever. What shall I call you?"
        }
        
        if lowercaseInput.contains("help") {
            return "Help? Oh, I can help you indeed... but first, tell me what troubles you."
        }
        
        if lowercaseInput.contains("magic") {
            return "Ah, magic... Yes, I have a particular interest in the more... advanced forms of magical study."
        }
        
        // Random responses for other inputs
        return fallbackResponses.randomElement() ?? "Write to me again... I find our conversation most intriguing."
    }
}
