//
//  PatientView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/30/24.
//

import SwiftUI

struct PatientView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject var viewModel = ExerciseViewModel()
    @State private var selectedStatus: ExerciseStatus = .pending

    init() {
        UISegmentedControl.appearance().selectedSegmentTintColor = UIColor(.medium)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.light)], for: .selected)
        UISegmentedControl.appearance().setTitleTextAttributes([.foregroundColor: UIColor(.medium)], for: .normal)
    }
    
    var body: some View {
        VStack {
            CustomTopBar()
            if let patient = AuthManager.shared.user {
                Picker("Status", selection: $selectedStatus) {
                    Text("Pending").tag(ExerciseStatus.pending)
                    Text("Completed").tag(ExerciseStatus.completed)
                }
                .pickerStyle(.segmented)
                .padding()
                
                List {
                    ForEach(viewModel.patientExercises.filter { $0.patientExercise.status == selectedStatus }) { patientExerciseResponse in
                        PatientExerciseCard(exercise: patientExerciseResponse.exercise, patientExercise: patientExerciseResponse.patientExercise)
                            .background(
                                NavigationLink("", destination: PatientExerciseDetailView(exercise: patientExerciseResponse.exercise, patientExercise: patientExerciseResponse.patientExercise, showStart: selectedStatus == .pending))
                                    .opacity(0)
                            )
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .padding(.vertical, 5)
                    }
                }
                .listStyle(PlainListStyle())
                .refreshable {
                    viewModel.fetchPatientExercises(patientID: patient.id)
                }
            }
        }
        .background(.darkest)
        .onAppear {
            if let patient = AuthManager.shared.user {
                viewModel.fetchPatientExercises(patientID: patient.id)
            }
        }
    }
}

//#Preview {
//    PatientView()
//}
