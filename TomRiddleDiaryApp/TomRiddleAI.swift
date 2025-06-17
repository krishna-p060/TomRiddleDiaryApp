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
