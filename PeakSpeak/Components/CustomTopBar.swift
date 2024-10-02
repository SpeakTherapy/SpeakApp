//
//  CustomTopBar.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/31/24.
//

import SwiftUI

struct CustomTopBar: View {
    var body: some View {
        HStack {
            Image("SpeakLogo") // Replace with your logo image
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.leading, 16)
            
            Text("PeakSpeak")
                .font(.title2)
                .fontWeight(.bold)
                .padding(.leading, 4)
            Spacer()
        }
        .frame(height: 44)
        .background(Color.darkest)
    }
}

#Preview {
    CustomTopBar()
}
