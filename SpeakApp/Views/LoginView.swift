//
//  LoginView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack {
            TextField("Email", text: $email)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            SecureField("Password", text: $password)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Login") {
                authViewModel.login(email: email, password: password)
            }
            .padding()
            
            if let errorMessage = authViewModel.errorMessage {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }
            
            NavigationLink(destination: SignupView().environmentObject(authViewModel)) {
                Text("Don't have an account? Sign up")
            }
        }
        .navigationTitle("Login")
    }
}

//#Preview {
//    LoginView()
//}
