//
//  OnboardingManager.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 17/06/25.
//

import Foundation
import Combine
import SwiftUI

class OnboardingManager: ObservableObject {
    @Published var showOnboarding: Bool
    
    private let hasCompletedOnboardingKey = "hasCompletedOnboarding"
    
    init() {
        // Check if user has completed onboarding before
        self.showOnboarding = !UserDefaults.standard.bool(forKey: hasCompletedOnboardingKey)
    }
    
    func completeOnboarding() {
        UserDefaults.standard.set(true, forKey: hasCompletedOnboardingKey)
        withAnimation(.easeInOut(duration: 0.5)) {
            showOnboarding = false
        }
    }
    
    // For testing - reset onboarding
    func resetOnboarding() {
        UserDefaults.standard.removeObject(forKey: hasCompletedOnboardingKey)
        showOnboarding = true
    }
}
