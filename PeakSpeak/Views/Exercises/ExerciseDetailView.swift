//
//  ExerciseDetailView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/27/24.
//

import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise
    
    var body: some View {
        VStack {
            Text(exercise.description)
                .font(.body)
                .padding()
            
            HStack{
                ForEach(exercise.tags, id: \.self) { tag in
                    TagView(tag: tag, isSelected: true, isSelectable: false)
                }
            }
            
            Spacer()

        }
        .frame(maxWidth: .infinity)
        .background(.darkest)
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    ExerciseDetailView()
//}
