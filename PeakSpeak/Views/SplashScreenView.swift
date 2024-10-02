//
//  SplashScreenView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import SwiftUI

struct SplashScreenView: View {
    var body: some View {
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
            Spacer()
        }
        .edgesIgnoringSafeArea(.all)
        .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/)
        .background(.darkest)
    }
}

//#Preview {
//    SplashScreenView()
//}
