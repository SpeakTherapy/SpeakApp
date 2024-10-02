//
//  AddExerciseView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/27/24.
//

import SwiftUI

struct AddExerciseView: View {
    let patient: User
    @StateObject private var viewModel = ExerciseViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack {
                    ForEach(viewModel.exercises) { exercise in
                        AddExerciseCard(
                            exercise: exercise,
                            isChecked: Binding(
                                get: {
                                    viewModel.selectedExercises.contains(exercise.id)
                                },
                                set: { isChecked in
                                    if isChecked {
                                        viewModel.selectedExercises.insert(exercise.id)
                                    } else {
                                        viewModel.selectedExercises.remove(exercise.id)
                                    }
                                }
                            )
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.top, 10)
            }
            Spacer()
            Text("Selected Exercises: \(viewModel.selectedExercises.count)")
                .padding()
            
            Button(action: {
                viewModel.assignExercisesToPatient(patientID: patient.id)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Assign")
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.light)
                    .cornerRadius(10)
            }
            .disabled(viewModel.selectedExercises.count < 1)
            .padding()
        }
        .background(.darkest)
        .onAppear {
            viewModel.fetchExercises()
        }
        .navigationTitle("Add Exercises to \(patient.firstName) \(patient.lastName)")
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    AddExerciseView()
//}
