//
//  MainTabView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/29/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        TabView {
            if authViewModel.user?.role == .therapist {
                PatientListView()
                    .tabItem {
                        Image(systemName: "person.3")
                        Text("Patients")
                    }
                
                ExerciseListView()
                    .tabItem {
                        Image(systemName: "list.bullet")
                        Text("Exercises")
                    }
            }
            
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.crop.circle")
                    Text("Profile")
                }
        }
    }
}


//#Preview {
//    MainTabView()
//}
