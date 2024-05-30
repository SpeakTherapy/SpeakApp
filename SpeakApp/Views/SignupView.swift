//
//  SignupView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var name = ""
    @State private var email = ""
    @State private var password = ""
    @State private var role: UserRole = .patient
    
    var body: some View {
        VStack {
            TextField("Name", text: $name)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Picker("Role", selection: $role) {
                Text("Patient").tag(UserRole.patient)
                Text("Therapist").tag(UserRole.therapist)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
            Button("Sign Up") {
                authViewModel.signup(name: name, email: email, password: password, role: role)
            }
            .padding()
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
        }
        .navigationTitle("Sign Up")
    }
}


//#Preview {
//    SignupView()
//}
