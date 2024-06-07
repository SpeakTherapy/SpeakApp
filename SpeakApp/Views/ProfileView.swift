//
//  ProfileView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/29/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ProfileViewModel()
    
    var body: some View {
        VStack {
            if let user = authViewModel.user {
                Text("ID: \(user.id!))")
                Text("Name: \(user.name)")
                Text("Email: \(user.email)")
                Text("Role: \(user.role.rawValue.capitalized)")
                
                if let referenceCode = user.referenceCode {
                    Text("Reference Code: \(referenceCode)")
                }
                
                if user.role == .patient {
                    if user.referenceCode != nil {
                        if viewModel.therapistName != "" {
                            Text("Therapist: \(viewModel.therapistName)")
                        } else {
                            Text("You are linked to a therapist.")
                        }
                    } else {
                        TextField("Enter therapist reference code", text: $viewModel.therapistReferenceCode)
                            .padding()
                            .background(Color.gray.opacity(0.2))
                            .cornerRadius(5)
                        
                        Button("Link to Therapist") {
                            viewModel.linkToTherapist(user: user)
                        }
                    }
                }
//                if user.role == .patient {
//                    if viewModel.isLinkedToTherapist {
//                        if let therapist = viewModel.patient?.therapist {
//                            Text("Therapist: \(therapist.name)")
//                        } else {
//                            Text("You are linked to a therapist.")
//                        }
//                    } else {
//                        TextField("Enter therapist reference code", text: $viewModel.therapistReferenceCode)
//                            .padding()
//                            .background(Color.gray.opacity(0.2))
//                            .cornerRadius(5)
//                        
//                        Button("Link to Therapist") {
//                            viewModel.linkToTherapist(user: user)
//                        }
//                    }
//                }
                
                Button("Logout") {
                    authViewModel.user = nil
                }
                .padding()
            }
        }
        .padding()
        .navigationTitle("Profile")
        .onAppear {
            if let user = authViewModel.user {
                viewModel.fetchSelf(userID: user.id!)
            }
        }
        .alert(isPresented: $viewModel.showingAlert) {
            Alert(title: Text("Info"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
        }
    }
}


//#Preview {
//    ProfileView()
//}
