//
//  ContentView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showSplash = true

    var body: some View {
        NavigationView {
            if showSplash {
                SplashScreenView()
                    .transition(.opacity)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { // Show splash screen for 3 seconds
                            withAnimation {
                                showSplash = false
                            }
                        }
                    }
            } else {
                if let user = authViewModel.user {
                    MainTabView()
                        .environmentObject(authViewModel)
                } else {
                    LandingView()
                        .environmentObject(authViewModel)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
