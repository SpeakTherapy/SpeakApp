//
//  ContentView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import SwiftUI


struct ContentView: View {
    @StateObject private var authManager = AuthManager.shared
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
                if authManager.user != nil {
                    MainTabView()
                        .environmentObject(authManager)
                } else {
                    LandingView()
                        .environmentObject(authManager)
                }
            }
        }
    }
}


//#Preview {
//    ContentView()
//}
