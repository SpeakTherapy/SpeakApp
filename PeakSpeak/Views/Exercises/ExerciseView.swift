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
    
    @State private var selectedCategory: ExerciseFilter = .global

    var body: some View {
        VStack {
            // If the user is a therapist, show a segmented Picker
            if authManager.user?.role == .therapist {
                Picker("Exercise Category", selection: $selectedCategory) {
                    ForEach(ExerciseFilter.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                // Whenever selectedCategory changes, fetch the respective exercises
                .onChange(of: selectedCategory) { newCategory in
                    fetchData(for: newCategory)
                }
            }
            
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
            .refreshable {
                // Pull-to-refresh logic
                if authManager.user?.role == .therapist {
                    viewModel.exercises = []
                    refreshBasedOnCategory(selectedCategory)
                } else if authManager.user?.role == .patient {
                    // Patient logic remains the same
                    viewModel.fetchPatientExercises(patientID: AuthManager.shared.user!.userId)
                }
            }
            
            Spacer()
            
            // Only show the "Create Exercise" button if user is a therapist
            if authManager.user?.role == .therapist {
                HStack {
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
        .background(Color.darkest)
        .onAppear {
            // Decide which fetch to perform when the view first appears
            if authManager.user?.role == .therapist {
                fetchData(for: selectedCategory)
            } else if authManager.user?.role == .patient {
                viewModel.fetchPatientExercises(patientID: AuthManager.shared.user!.userId)
            }
        }
    }
    
    /// Fetch exercises based on the selected category for therapists
    private func refreshBasedOnCategory(_ category: ExerciseFilter) {
        guard let user = authManager.user else { return }
        
        switch category {
        case .global:
            viewModel.fetchGlobalExercises()
        case .therapist:
            viewModel.fetchTherapistExercises(therapistID: user.id)
        }
    }
    
    // MARK: - Helper function for handling filter changes
    private func fetchData(for category: ExerciseFilter) {
        viewModel.exercises = []
        
        switch category {
        case .global:
            // If you want to use the cached data if it exists,
            // check if `viewModel.globalExercises` is empty.
            if viewModel.globalExercises.isEmpty {
                // Perform network fetch since we have no cached global exercises
                viewModel.fetchGlobalExercises()
            } else {
                // Use cached data
                viewModel.exercises = []
                viewModel.exercises = viewModel.globalExercises
            }

        case .therapist:
            // Only fetch if user is a therapist and we have a valid ID
            guard let therapistID = authManager.user?.id,
                  authManager.user?.role == .therapist else {
                viewModel.exercises = []
                return
            }
            // Check if therapistExercises is already cached
            if viewModel.therapistExercises.isEmpty {
                viewModel.fetchTherapistExercises(therapistID: therapistID)
            } else {
                viewModel.exercises = viewModel.therapistExercises
            }
        }
    }
}

//#Preview {
//    ExerciseView()
//}
