//
//  BackButton.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/30/24.
//

import SwiftUI

struct BackButton: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Button(action: {
            presentationMode.wrappedValue.dismiss()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                    .foregroundColor(Color.medium)
            }
            .padding()
            Spacer()
        }
        .padding()
    }
}

//#Preview {
//    BackButtonView()
//}

