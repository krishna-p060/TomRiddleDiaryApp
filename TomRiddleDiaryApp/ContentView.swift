//
//  ContentView.swift
//  TomRiddleDiaryApp
//
//  Created by Apple on 16/06/25.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        DiaryPageView()
            .ignoresSafeArea(.all)
            .background(
                // Aged paper background
                Color(red: 0.98, green: 0.95, blue: 0.87)
                    .ignoresSafeArea(.all)
            )
            .preferredColorScheme(.light)
    }
}

#Preview {
    ContentView()
}
