//
//  MainView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import SwiftUI

struct MainTabView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var selectedTab: Int = 0

    init() {
        UITabBar.appearance().isHidden = true
        UITabBar.appearance().unselectedItemTintColor = UIColor.darkGray
    }

    var body: some View {
        ZStack {
            TabView(selection: $selectedTab) {
                if authManager.user?.role == .therapist {
                    TherapistView()
                        .tabItem {
                            Image(systemName: "person.3")
                            Text("Patients")
                        }
                        .tag(0)
                    
                    ExerciseView()
                        .tabItem {
                            Image(systemName: "list.bullet")
                            Text("Exercises")
                        }
                        .tag(1)
                } else {
                    PatientView()
                        .tabItem {
                            Image(systemName: "house.fill")
                            Text("Home")
                        }
                        .tag(0)
                }
                
                ProfileView()
                    .tabItem {
                        Image(systemName: "person.crop.circle")
                        Text("Profile")
                    }
                    .tag(2)
            }

            VStack {
                Spacer()
                
                HStack {
                    if authManager.user?.role == .therapist {
                        TabButton(icon: "person.3", isSelected: selectedTab == 0) {
                            selectedTab = 0
                        }
                        
                        Spacer()
                        
                        TabButton(icon: "list.bullet", isSelected: selectedTab == 1) {
                            selectedTab = 1
                        }
                    } else {
                        TabButton(icon: "house.fill", isSelected: selectedTab == 0) {
                            selectedTab = 0
                        }
                    }
                    
                    Spacer()
                    
                    TabButton(icon: "person.crop.circle", isSelected: selectedTab == 2) {
                        selectedTab = 2
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, authManager.user?.role == .therapist ? 30 : 50) // Adjust padding based on role
                .background(.darkBack)
                .clipShape(Capsule())
                .shadow(color: Color.black.opacity(0.2), radius: 10, x: 0, y: 5)
                .padding(.bottom, 10)
                .padding(.horizontal, authManager.user?.role == .therapist ? 20 : 60) // Adjust padding based on role
            }
        }
    }
}

struct TabButton: View {
    let icon: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .fontWeight(.bold)
                .foregroundColor(isSelected ? .light : .gray)
                .padding(.vertical, 10)
                .padding(.horizontal, 15)
        }
    }
}


//struct MainTabView_Previews: PreviewProvider {
//    static var previews: some View {
//        MainTabView().environmentObject(AuthManager())
//    }
//}
