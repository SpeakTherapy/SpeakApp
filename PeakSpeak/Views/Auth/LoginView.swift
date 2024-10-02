//
//  LoginView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var email = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentationMode
    @State private var isEmailActive = false
    @State private var isPasswordActive = false
    
    var body: some View {
        VStack {
            HStack {
                BackButton()
                Spacer()
            }
            Spacer()
            Image("SpeakLogo")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            
            Text("Login")
                .font(.largeTitle)
                .fontWeight(.bold)
                .foregroundStyle(.light)
                .padding(.bottom, 20)
            Spacer()
            
            CustomTextField(text: $email, placeholder: "Email", isSecure: false, isActive: isEmailActive)
                .modifier(CustomTextFieldModifier(isActive: isEmailActive))
                .padding(.vertical, 20)
                .onTapGesture {
                    isEmailActive = true
                    isPasswordActive = false
                }
                .frame(maxHeight: .leastNormalMagnitude)
                .padding(.bottom, 50)
            
            CustomTextField(text: $password, placeholder: "Password", isSecure: true, isActive: isPasswordActive)
                .modifier(CustomTextFieldModifier(isActive: isPasswordActive))
                .onTapGesture {
                    isEmailActive = false
                    isPasswordActive = true
                }
                .frame(maxHeight: .leastNormalMagnitude)
                .padding(.bottom, 20)
            
            Button(action: {
                authManager.login(email: email, password: password)
            }) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .padding()
                    .fontWeight(.bold)
                    .background(.medium)
                    .foregroundColor(.light)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 20)
            }
            if let error = authManager.loginError {
                Text(error).foregroundColor(.red)
            }
            Spacer()
        }
        .navigationBarHidden(true)
        .background(.darkest)
        .addDismissKeyboardGesture()
    }
}


//#Preview {
//    LoginView()
//}
