//
//  ContentView.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 16/06/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var onboardingManager = OnboardingManager()
    
    var body: some View {
        ZStack {
            if onboardingManager.showOnboarding {
                OnboardingView {
                    onboardingManager.completeOnboarding()
                }
                .transition(.opacity)
            } else {
                DiaryPageView()
                    .transition(.opacity)
            }
        }
        .animation(.easeInOut(duration: 0.5), value: onboardingManager.showOnboarding)
    }
}

#Preview {
    ContentView()
}
