//
//  ExerciseView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/23/24.
//

import SwiftUI

struct ExerciseView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel = ExerciseViewModel()
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.exercises) { exercise in
                        NavigationLink(destination: ExerciseDetailView(exercise: exercise)) {
                            ExerciseCard(exercise: exercise)
                                .padding(.bottom, 10)
                        }
                    }
                    
                }
            }
            Spacer()
            if authManager.user?.role == .therapist {
                HStack{
                    NavigationLink(destination: CreateExerciseView()) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title)
                            .foregroundColor(Color.light)
                    }
                }
                .padding(.bottom, 90)
            }
        }
        .navigationTitle("Exercises")
        .background(.darkest)
        .refreshable {
            print("trying to refresh exercises here")
            if authManager.user?.role == .therapist {
                viewModel.fetchExercises()
            }
        }
    }
}

//#Preview {
//    ExerciseView()
//}
