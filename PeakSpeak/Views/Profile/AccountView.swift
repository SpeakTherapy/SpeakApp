//
//  AccountView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 8/26/24.
//

import SwiftUI

struct AccountView: View {
    @StateObject private var authManager = AuthManager.shared
    @State private var showDeleteAlert = false // State to control the display of the alert
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                BackButton()
                Spacer()
            }
            
            List {
                Section(header: Text("Account")){
                    // Sign Out Button
                    Button(action: {
                        authManager.logout()
                    }) {
                        HStack {
                            Image(systemName: "arrow.backward.square") // Exit icon
                            Text("Sign out")
                        }
                    }
                    
                    // Delete Account Button
                    Button(action: {
                        showDeleteAlert = true // Trigger the alert
                    }) {
                        HStack {
                            Image(systemName: "trash") // Trash icon for delete
                            Text("Delete Account")
                        }
                        .foregroundColor(.red) // Optional: Make delete account button red
                    }
                    .alert(isPresented: $showDeleteAlert) {
                        Alert(
                            title: Text("Delete Account"),
                            message: Text("Are you sure you want to delete your account? This action cannot be undone."),
                            primaryButton: .destructive(Text("Delete")) {
                                authManager.deleteUser { success in
                                    if success {
                                        presentationMode.wrappedValue.dismiss()
                                    } else {
                                        showDeleteAlert = true
                                    }
                                }
                            },
                            secondaryButton: .cancel()
                        )
                    }
                }
                .headerProminence(.increased)
                .listRowBackground(Color.darkBack)
            }
            .scrollContentBackground(.hidden)
            .listStyle(InsetGroupedListStyle()) // Optional: Adjust the list style to fit your design
            
            Spacer()
        }
        .background(.darkest)
        .foregroundColor(.light)
        .navigationBarHidden(true)
    }
}

//#Preview {
//    AccountView()
//}
