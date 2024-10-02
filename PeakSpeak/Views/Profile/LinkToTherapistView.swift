//
//  LinkToTherapistView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 8/26/24.
//

import SwiftUI

struct LinkToTherapistView: View {
    @State private var referenceCode: String = ""
    @State private var isReferenceCodeActive: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""

    var body: some View {
        VStack {
            HStack {
                BackButton()
                Spacer()
            }
            
            Section("Reference Code") {
                CustomTextField(text: $referenceCode, placeholder: "Reference Code", isSecure: false, isActive: isReferenceCodeActive)
                    .modifier(CustomTextFieldModifier(isActive: isReferenceCodeActive))
                    .padding(.vertical, 20)
                    .onTapGesture {
                        isReferenceCodeActive = true
                    }
                    .frame(maxHeight: .leastNormalMagnitude)
                    .padding(.vertical, 30)

                Button(action: {
                    linkToTherapist()
                }) {
                    Text("Link to Therapist")
                        .padding()
                        .background(Color.medium)
                        .foregroundColor(.light)
                        .cornerRadius(8)
                }
            }
            Spacer()
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Link to Therapist"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
        .addDismissKeyboardGesture()
        .background(Color.darkest)
        .navigationBarHidden(true)
    }

    private func linkToTherapist() {
        AuthManager.shared.linkToTherapist(referenceCode: referenceCode)
        
        // Delay the check for error until after the network call completes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            if let error = AuthManager.shared.linkError {
                alertMessage = "Failed to link to therapist. \(error)"
            } else {
                alertMessage = "Successfully linked to therapist."
            }
            showAlert = true
        }
    }
}


//#Preview {
//    LinkToTherapistView()
//}
