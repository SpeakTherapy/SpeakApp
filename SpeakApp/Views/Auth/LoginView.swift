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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                BackButton()
                Spacer()
            }
            Spacer()
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 20)
            
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
            
            Spacer()
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    LoginView()
}
