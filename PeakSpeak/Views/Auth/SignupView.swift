//
//  SignupView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import SwiftUI

struct SignupView: View {
    @EnvironmentObject var authManager: AuthManager
    
    var body: some View {
        VStack {
            HStack {
                BackButton()
                Spacer()
            }
            Spacer()

            Text("Choose your role")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 40)

            HStack {
                VStack {
                    Image(systemName: "person.crop.circle")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(AuthManager.shared.role == .patient ? .bright.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                        .onTapGesture {
                            print("tapped patient")
                            AuthManager.shared.role = .patient
                        }
                    Text("Patient")
                        .font(.title2)
                }
                .padding()

                VStack {
                    Image(systemName: "stethoscope")
                        .resizable()
                        .frame(width: 100, height: 100)
                        .padding()
                        .background(AuthManager.shared.role == .therapist ? .bright.opacity(0.2) : Color.clear)
                        .clipShape(Circle())
                        .onTapGesture {
                            print("Tapped therapist")
                            AuthManager.shared.role = .therapist
                        }
                    Text("Therapist")
                        .font(.title2)
                }
                .padding()
            }

            NavigationLink(destination: SignupStep2View()) {
                Text("Next")
                    .frame(maxWidth: .infinity)
                    .font(.title3)
                    .padding()
                    .fontWeight(.bold)
                    .background(.medium)
                    .foregroundColor(.light)
                    .cornerRadius(8)
                    .padding(.horizontal)
                    .padding(.top, 40)
            }

            Spacer()
            Spacer()
        }
        .padding()
        .background(.darkest)
        .navigationBarHidden(true)
    }
    
}
