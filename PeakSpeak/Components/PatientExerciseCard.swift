//
//  PatientExerciseCard.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/29/24.
//

import SwiftUI

struct PatientExerciseCard: View {
    let exercise: Exercise
    let patientExercise: PatientExercise
    
    @State private var isChecked: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                VStack(alignment: .leading, spacing: 5) { // Reduce spacing between elements
                    Text(exercise.name)
                        .font(.subheadline) // Smaller font size
                        .foregroundColor(.light) // Use system primary color
                    HStack {
                        ForEach(exercise.tags, id: \.self) { tag in
                            TagView(tag: tag, isSelected: true, isSelectable: false)
                                .font(.caption) // Smaller font size for tags
                        }
                    }
                }
                .padding(.vertical, 8) // Reduce vertical padding
                .padding(.horizontal, 10) // Reduce horizontal padding
                
                Spacer()
                
                Circle()
                    .fill(patientExercise.status == .pending ? Color.yellow : Color.green)
                    .frame(width: 16, height: 16) // Smaller circle
                    .padding(.trailing, 10) // Reduce trailing padding
            }
            .frame(width: geometry.size.width * 0.9)
            .background(Color.medium) // Light gray background color for the card
            .cornerRadius(10)
            .shadow(radius: 2)
            .padding(.horizontal)
        }
        .frame(height: 80) // Adjust the height as needed to make it more compact
    }
}


//#Preview {
//    PatientExerciseCard()
//}
