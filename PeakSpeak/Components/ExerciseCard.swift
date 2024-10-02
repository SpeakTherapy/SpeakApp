//
//  ExerciseCard.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/25/24.
//

import SwiftUI

struct ExerciseCard: View {
    let exercise: Exercise
    let status: ExerciseStatus? = nil
    
    @State private var isChecked: Bool = false
    
    var body: some View {
        GeometryReader { geometry in
            HStack {
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
                
                Spacer()
                
                if let status = status {
                    Circle()
                        .fill(status == .pending ? Color.yellow : Color.green)
                        .frame(width: 20, height: 20)
                        .padding()
                }
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
//    ExerciseCard()
//}
