//
//  PatientCard.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/25/24.
//

import SwiftUI

struct PatientCard: View {
    let patient: User
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                if let profileImage = patient.profileImage, !profileImage.isEmpty {
                    AsyncImage(url: URL(string: profileImage)) { image in
                        image.resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .padding(.leading, 16)
                    } placeholder: {
                        Circle()
                            .fill(Color.gray)
                            .frame(width: 50, height: 50)
                            .padding(.leading, 16)
                    }
                } else {
                    Image(systemName: "person.crop.circle.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 50, height: 50)
                        .foregroundColor(.gray)
                        .frame(width: 55, height: 55)
                        .background(Color(.systemGray6))
                        .cornerRadius(geometry.size.width / 6)
                        .padding(.leading, 16)
//                        .padding(.trailing, 10)
                }
                
                Text("\(patient.firstName) \(patient.lastName)")
                    .font(.headline)
                    .foregroundColor(.light)
                
                Spacer()
                    
                }
                .frame(width: geometry.size.width * 0.9, height: 70)
                .background(.medium) // Light blue background color for the card
                .cornerRadius(10)
                .shadow(radius: 5)
                .padding(.horizontal)
        }
        .frame(height: 100) // Adjust the height as needed
    }
}

//#Preview {
//    PatientCard()
//}
