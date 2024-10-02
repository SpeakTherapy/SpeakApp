//
//  BackButton.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
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
                    .foregroundColor(.medium)
                Spacer()
            }
            .padding()
            Spacer()
        }
        .padding()
    }
}

//#Preview {
//    BackButton()
//}
