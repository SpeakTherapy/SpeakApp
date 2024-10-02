//
//  SignupStep2View.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/31/24.
//

import SwiftUI

struct SignupStep2View: View {
    @StateObject private var authManager = AuthManager.shared
    
    @State private var isFirstNameActive = false
    @State private var isLastNameActive = false
    @State private var isEmailActive = false
    
    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.medium)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.light)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.medium)], for: .normal)
    }
    
    private func isEmailValid(email: String) -> Bool {
        let emailRegex = "^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", emailRegex)

        return emailTest.evaluate(with: email)
    }
    
    var body: some View {
        VStack {
            HStack {
                BackButton()
            }
            Spacer()
            
            HStack {
                Text("Tell us about yourself")
                    .font(.title2)
                    .foregroundStyle(Color.light)
                    .fontWeight(.bold)
                Spacer()
            }.padding(.horizontal)
            CustomTextField(text: $authManager.firstName, placeholder: "First Name", isSecure: false, isActive: isFirstNameActive)
                .modifier(CustomTextFieldModifier(isActive: isFirstNameActive))
                .onTapGesture {
                    isFirstNameActive = true
                    isLastNameActive = false
                    isEmailActive = false
                }
                .frame(maxHeight: .leastNormalMagnitude)
                .padding(.top, 20)
                .padding(.bottom, 60)
            
            CustomTextField(text: $authManager.lastName, placeholder: "Last Name", isSecure: false, isActive: isLastNameActive)
                .modifier(CustomTextFieldModifier(isActive: isLastNameActive))
                .onTapGesture {
                    isFirstNameActive = false
                    isLastNameActive = true
                    isEmailActive = false
                }
                .padding(.bottom, 45)
                .frame(height: 30)
            
            CustomTextField(text: $authManager.email, placeholder: "Email", isSecure: false, isActive: isEmailActive)
                .modifier(CustomTextFieldModifier(isActive: isEmailActive))
                .onTapGesture {
                    isFirstNameActive = false
                    isLastNameActive = false
                    isEmailActive = true
                }
                .padding(.bottom, 0)
                .textInputAutocapitalization(.never)
                .frame(height: 30)
            
            if !authManager.email.isEmpty && !isEmailValid(email: authManager.email) {
                Text("Email is formatted incorrectly")
                    .foregroundStyle(.red)
            }
            Spacer()
            NavigationLink(destination: SignupStep3View()) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .padding()
                    .fontWeight(.bold)
                    .background(authManager.firstName.isEmpty || authManager.lastName.isEmpty || authManager.email.isEmpty ? Color.gray : Color.medium) // Conditional background color
                    .foregroundColor(.light)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .disabled(authManager.firstName.isEmpty || authManager.lastName.isEmpty || authManager.email.isEmpty || !isEmailValid(email: authManager.email))

            Spacer()
            Spacer()
        }
        .addDismissKeyboardGesture()
        .padding()
        .background(.darkest)
        .navigationBarHidden(true)
    }
}

//#Preview {
//    SignupStep2View()
//}
