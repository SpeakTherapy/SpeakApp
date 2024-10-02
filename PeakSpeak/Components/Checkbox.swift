//
//  Checkbox.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/28/24.
//

import SwiftUI

struct Checkbox: View {
    @Binding var isChecked: Bool

    var body: some View {
        Button(action: {
            isChecked.toggle()
        }) {
            Image(systemName: isChecked ? "checkmark.square" : "square")
                .foregroundColor(isChecked ? .darkBack : .gray)
        }
        .padding(.horizontal)
    }
}

//#Preview {
//    Checkbox()
//}
