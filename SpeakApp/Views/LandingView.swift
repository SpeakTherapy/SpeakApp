//
//  LandingView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/30/24.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject var authViewModel: AuthViewModel

    var body: some View {
        VStack {
            Spacer()
            Image("SpeakLogo") // Replace with your logo
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            Text("SpeakApp")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        
            NavigationLink(destination: LoginView().environmentObject(authViewModel)) {
                Text("Login")
                    .frame(maxWidth: .infinity)
                    .font(.title2)
                    .padding(.vertical, 10)
                    .fontWeight(.bold)
                    .background(Color.light)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
            .padding(.bottom, 10)
            
            NavigationLink(destination: SignupView().environmentObject(authViewModel)) {
                    Text("Sign Up")
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .font(.title2)
                        .fontWeight(.bold)
                        .background(Color.light)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
            .padding(.bottom, 10)
            Spacer()
        }
    }
}

#Preview {
    LandingView()
}
