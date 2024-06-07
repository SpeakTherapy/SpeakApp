//
//  SplashScreenView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/30/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("SpeakLogo") // Replace with your splash screen image
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 150)
            Text("SpeakApp")
                .font(.largeTitle)
                .fontWeight(.bold)
            Spacer()
        }
        .background(Color.white) // Set the background color
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    SplashScreenView()
}
