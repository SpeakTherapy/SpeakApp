//
//  SignupStep3View.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/31/24.
//

import SwiftUI

struct SignupStep3View: View {
    @StateObject private var authManager = AuthManager.shared
    
    @State private var isPasswordActive = false
    @State private var isConfirmActive = false
    
    var body: some View {
        VStack {
            HStack {
                BackButton()
            }
            Spacer()
            
            HStack {
                Text("Security is important!")
                    .font(.title2)
                    .foregroundStyle(Color.light)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.horizontal)
            
            CustomTextField(text: $authManager.password, placeholder: "Password", isSecure: true, isActive: isPasswordActive)
                .modifier(CustomTextFieldModifier(isActive: isPasswordActive))
                .onTapGesture {
                    isPasswordActive = true
                    isConfirmActive = false
                }
                .frame(maxHeight: .leastNormalMagnitude)
                .padding(.top, 20)
                .padding(.bottom, 55)
            
            CustomTextField(text: $authManager.confirmPassword, placeholder: "Confirm Password", isSecure: true, isActive: isConfirmActive)
                .modifier(CustomTextFieldModifier(isActive: isConfirmActive))
                .onTapGesture {
                    isPasswordActive = false
                    isConfirmActive = true
                }
                .frame(maxHeight: .leastNormalMagnitude)
                .padding(.bottom, 15)
            
            Button(action: {
                if authManager.password != authManager.confirmPassword {
                    authManager.signupError = "Passwords do not match"
                    return
                }
                authManager.signup(firstName: authManager.firstName, lastName: authManager.lastName, email: authManager.email, password: authManager.password, role: authManager.role.rawValue)
            }) {
                Text("Sign Up")
                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .padding()
                    .fontWeight(.bold)
                    .background(authManager.password.isEmpty || authManager.confirmPassword.isEmpty ? Color.gray : Color.medium)
                    .foregroundColor(.light)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 30)
            }
            .disabled(authManager.password.isEmpty || authManager.confirmPassword.isEmpty)

            if let errorMessage = authManager.signupError {
                Text(errorMessage)
                    .foregroundColor(.red)
                    .padding()
            }

            Spacer()
            Spacer()
        }
        .addDismissKeyboardGesture()
        .padding()
        .background(.darkest)
        .navigationBarHidden(true)
    }
}

#Preview {
    SignupStep3View()
}
