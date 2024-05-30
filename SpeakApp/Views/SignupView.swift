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
    @State private var confirmPassword = ""
    @State private var role: UserRole = .patient
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                BackButton()
                Spacer()
            }
            Spacer()
            
            Text("Sign Up")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
            Picker("Role", selection: $role) {
                Text("Patient").tag(UserRole.patient)
                Text("Therapist").tag(UserRole.therapist)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding()
            
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
            
            SecureField("Confirm Password", text: $confirmPassword)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            
            Button("Sign Up") {
                if password != confirmPassword {
                    authViewModel.errorMessage = "Passwords do not match"
                    return
                }
                authViewModel.signup(name: name, email: email, password: password, role: role)
            }
            .padding()
            
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}


//#Preview {
//    SignupView()
//}
