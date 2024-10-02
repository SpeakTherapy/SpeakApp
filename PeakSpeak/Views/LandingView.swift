//
//  LandingView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import SwiftUI

struct LandingView: View {
    @EnvironmentObject var authManager: AuthManager

    var body: some View {
        ZStack {
            VStack {
                Spacer()
                Image("SpeakLogo") 
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150, height: 150)
                Text("PeakSpeak")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.light)
                Text("Welcome! Let's get started.")
                    .font(.title3)
                    .fontWeight(.bold)
                    .foregroundStyle(.light)
                    .padding(.vertical, 5)
                Spacer()
                
                NavigationLink(destination: LoginView().environmentObject(authManager)) {
                    Text("Sign in")
                        .frame(maxWidth: .infinity)
                        .font(.title3)
                        .padding(.vertical, 20)
                        .fontWeight(.bold)
                        .background(.medium)
                        .foregroundColor(.light)
                        .cornerRadius(8)
                        .padding(.horizontal)
                }
                .padding(.bottom, 10)
                Spacer()
            }
            
            VStack {
                Spacer()
                HStack {
                    Text("Don't have an account?")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.top, 15)
                    NavigationLink(destination: SignupView().environmentObject(authManager)) {
                        Text("Sign Up")
                            .font(.subheadline)
                            .fontWeight(.bold)
                            .foregroundColor(.bright)
                            .padding(.top, 15)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(.darkBack)
                .padding(.vertical, 15)
//                .cornerRadius(8)
//                .padding(.horizontal)
            }
            .edgesIgnoringSafeArea(.bottom)
        }
        .background(.darkest)
    }
}

//#Preview {
//    LandingView()
//}
