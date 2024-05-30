//
//  ExerciseListView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/29/24.
//

import SwiftUI

struct ExerciseListView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    
    var body: some View {
        List(viewModel.exercises) { exercise in
            VStack(alignment: .leading) {
                Text(exercise.title)
                    .font(.headline)
                Text(exercise.description)
                    .font(.subheadline)
            }
        }
        .onAppear {
            viewModel.fetchExercises()
        }
        .navigationTitle("Exercises")
    }
}


//#Preview {
//    ExerciseListView()
//}
