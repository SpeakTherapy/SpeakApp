//
//  ExerciseListView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/29/24.
//

import SwiftUI

struct ExerciseListView: View {
    @EnvironmentObject var authViewModel: AuthViewModel
    @StateObject private var viewModel = ExerciseViewModel()
    
    var body: some View {
        VStack{
            List(viewModel.exercises) { exercise in
                VStack(alignment: .leading) {
                    Text(exercise.title)
                        .font(.headline)
                    Text(exercise.description)
                        .font(.subheadline)
                }
            }
            Spacer()
            
            if authViewModel.user?.role == .therapist {
                HStack{
                    NavigationLink(destination: CreateExerciseView()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(Color.dark)
                    }
                }
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
