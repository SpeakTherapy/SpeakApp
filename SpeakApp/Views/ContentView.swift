//
//  ContentView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/22/24.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var authViewModel = AuthViewModel()
    
    var body: some View {
        NavigationView {
            if let user = authViewModel.user {
                MainTabView()
                    .environmentObject(authViewModel)
            } else {
                LoginView()
                    .environmentObject(authViewModel)
            }
        }
    }
}

//#Preview {
//    ContentView()
//}
