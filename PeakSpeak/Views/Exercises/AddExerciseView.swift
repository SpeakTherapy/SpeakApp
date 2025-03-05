import SwiftUI

struct AddExerciseView: View {
    let patient: User
    @StateObject private var viewModel = ExerciseViewModel()
    @Environment(\.presentationMode) var presentationMode
    
    // Track the filter category (global or therapist)
    @State private var selectedCategory: ExerciseFilter = .global
    
    var body: some View {
        VStack {
            // 1. Segmented Picker for Global vs Private (Therapist) — Only visible for therapists
            if AuthManager.shared.user?.role == .therapist {
                Picker("Exercise Category", selection: $selectedCategory) {
                    ForEach(ExerciseFilter.allCases) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                .pickerStyle(.segmented)
                .padding()
                // Whenever the user switches segments, fetch data
                .onChange(of: selectedCategory) { newCategory in
                    fetchData(for: newCategory)
                }
            }
            
            // 2. List of Exercises
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
            .refreshable {
                // Pull-to-refresh: Re-fetch based on the current category
                if AuthManager.shared.user?.role == .therapist {
                    refreshBasedOnCategory(selectedCategory)
                }
            }

            Spacer()
            
            // 3. Display how many exercises were selected
            Text("Selected Exercises: \(viewModel.selectedExercises.count)")
                .padding()
            
            // 4. "Assign" button
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
            .disabled(viewModel.selectedExercises.isEmpty)
            .padding()
        }
        .background(Color.darkest)
        .navigationTitle("Add Exercises to \(patient.firstName) \(patient.lastName)")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            // When the view first appears, decide which data to fetch
            // If user is a therapist, fetch the default category
            if AuthManager.shared.user?.role == .therapist {
                fetchData(for: selectedCategory)
            }
        }
    }
}

// MARK: - Helper Methods
extension AddExerciseView {
    /// Fetch exercises based on the selected category (Global or Therapist).
    /// Uses the same caching logic as your main ExerciseView to avoid redundant calls.
    private func fetchData(for category: ExerciseFilter) {
        guard let user = AuthManager.shared.user else { return }
        viewModel.exercises = []
        
        switch category {
        case .global:
            // If no cached global exercises, fetch from the server.
            if viewModel.globalExercises.isEmpty {
                viewModel.fetchGlobalExercises()
            } else {
                viewModel.exercises = viewModel.globalExercises
            }
            
        case .therapist:
            // Make sure user is a therapist and we have an ID
            if user.role == .therapist, !user.id.isEmpty {
                if viewModel.therapistExercises.isEmpty {
                    viewModel.fetchTherapistExercises(therapistID: user.id)
                } else {
                    viewModel.exercises = viewModel.therapistExercises
                }
            } else {
                // Not a therapist or missing ID, so no exercises to show
                viewModel.exercises = []
            }
        }
    }
    
    /// Pull-to-refresh re-fetch logic to always grab fresh data from server
    private func refreshBasedOnCategory(_ category: ExerciseFilter) {
        guard let user = AuthManager.shared.user else { return }
        
        viewModel.exercises = []
        switch category {
        case .global:
            // Force a new fetch from server
            viewModel.fetchGlobalExercises()
        case .therapist:
            if user.role == .therapist {
                viewModel.fetchTherapistExercises(therapistID: user.id)
            }
        }
    }
}
