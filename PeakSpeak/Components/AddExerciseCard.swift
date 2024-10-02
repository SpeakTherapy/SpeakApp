//
//  AddExerciseCard.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/28/24.
//

import SwiftUI

struct AddExerciseCard: View {
    let exercise: Exercise
    @Binding var isChecked: Bool
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
                
                NavigationLink(destination: ExerciseDetailView(exercise: exercise)){
                    VStack(alignment: .leading) {
                        Text(exercise.name)
                            .font(.headline)
                            .foregroundColor(.light)
                        HStack {
                           ForEach(exercise.tags, id: \.self) { tag in
                               TagView(tag: tag, isSelected: true, isSelectable: false)
                           }
                       }
                    }
                    .padding()
                }
                Spacer()
                
                Checkbox(isChecked: $isChecked)
                
                
            }
            .frame(width: geometry.size.width * 0.9)
            .background(.medium) // Light blue background color for the card
            .cornerRadius(10)
            .shadow(radius: 5)
            .padding(.horizontal)
        }
        .frame(height: 100) // Adjust the height as needed
    }
}

//#Preview {
//    AddExerciseCard()
//}
