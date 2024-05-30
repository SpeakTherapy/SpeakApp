//
//  ProfileView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/29/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    
    var body: some View {
        VStack {
            if let user = authViewModel.user {
                Text("Name: \(user.name)")
                Text("Email: \(user.email)")
                Text("Role: \(user.role.rawValue.capitalized)")
                
                if let referenceCode = user.referenceCode {
                    Text("Reference Code: \(referenceCode)")
                }
            }
            
            Button("Logout") {
                authViewModel.user = nil
            }
            .padding()
        }
        .navigationTitle("Profile")
    }
}


//#Preview {
//    ProfileView()
//}
