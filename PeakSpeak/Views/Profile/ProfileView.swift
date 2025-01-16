//
//  ProfileView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var authManager: AuthManager
    @State private var referenceCode: String = ""
    @State private var isImagePickerPresented = false
    @State private var selectedImage: UIImage?
    @State private var isReferenceCodeVisible = false
    @State private var showCopyAlert = false

    
    var body: some View {
        VStack {
            if let user = authManager.user {
                
                // Profile Picture
                if let profilePictureURL = user.profileImage, !profilePictureURL.isEmpty {
                    AsyncImage(url: URL(string: profilePictureURL)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 150, height: 150)
                            .clipShape(Circle())
                            .onTapGesture {
                                isImagePickerPresented = true
                            }
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 150, height: 150)
                    }
                } else {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 150, height: 150)
                        .overlay(Text("Tap to select image").foregroundColor(.white))
                        .onTapGesture {
                            isImagePickerPresented = true
                        }
                }
                
                // User Name
                Text("\(user.firstName) \(user.lastName)")
                    .font(.title2)
                    .fontWeight(.bold)
                    .padding(.top)
                
                // Inside your VStack or appropriate container
                if user.role == .therapist {
                    HStack {
                        Text("Reference Code:")
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        if isReferenceCodeVisible {
                            Text(user.referenceCode)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .onTapGesture {
                                    // Copy to clipboard
                                    UIPasteboard.general.string = user.referenceCode
                                    showCopyAlert = true
                                }
                        } else {
                            Text("••••••••••")
                                .font(.title3)
                                .foregroundColor(.secondary)
                        }
                        
                        Button(action: {
                            isReferenceCodeVisible.toggle()
                        }) {
                            Image(systemName: isReferenceCodeVisible ? "eye.slash.fill" : "eye.fill")
                                .foregroundColor(.blue)
                        }
                    }
                    .padding(.vertical)
                    .alert(isPresented: $showCopyAlert) {
                        Alert(title: Text("Copied"), message: Text("Reference code copied to clipboard."), dismissButton: .default(Text("OK")))
                    }
                }

                
                // List of Options
                VStack{
                    List {
                        Section {
                            NavigationLink(destination: AccountView()) {
                                Text("Account")
                            }
                            // Link to Therapist Section (only for patients)
                            if user.role == .patient {
                                if user.referenceCode.isEmpty {
                                    NavigationLink(destination: LinkToTherapistView()) {
                                        Text("Link to Therapist")
                                    }

                                } else {
                                    Text("Linked to Therapist")
                                        .foregroundColor(.green)
                                }
                            }
                        }.listRowBackground(Color.darkBack)
                    }
                    .scrollContentBackground(.hidden)
                    .listStyle(InsetGroupedListStyle())
                }
                .background(Color.darkest) // Ensure list background matches
                                
                Spacer()
            }
        }
        .padding()
        .background(Color.darkest.edgesIgnoringSafeArea(.all)) // Match the entire view's background
        .foregroundColor(.light)
        .navigationTitle("Profile")
        .sheet(isPresented: $isImagePickerPresented) {
            ImagePicker(image: $selectedImage)
        }
        .onChange(of: selectedImage) { newImage in
            if let newImage = newImage {
                authManager.uploadProfilePicture(image: newImage)
            }
        }
    }
}

//#Preview {
//    ProfileView()
//}
