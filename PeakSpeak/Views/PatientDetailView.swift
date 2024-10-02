//
//  PatientDetailView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/27/24.
//

import SwiftUI

struct PatientDetailView: View {
    let patient: User
    @StateObject var viewModel = ExerciseViewModel()
    
    var body: some View {
        VStack {
            if let profileImage = patient.profileImage, !profileImage.isEmpty {
                AsyncImage(url: URL(string: profileImage)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 50, height: 50)
                        .clipShape(Circle())
                } placeholder: {
                    Circle()
                        .fill(Color.gray)
                        .frame(width: 50, height: 50)
                }
            } else {
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                    .frame(width: 55, height: 55)
                    .background(Color(.systemGray6))
                    .cornerRadius(25)
                    .padding(.leading, 16)
                    .padding(.trailing, 10)
            }
            
            Text("\(patient.firstName) \(patient.lastName)")
                .font(.subheadline)
            List {
                ForEach(viewModel.patientExercises) { patientExerciseResponse in
                    PatientExerciseCard(exercise: patientExerciseResponse.exercise, patientExercise: patientExerciseResponse.patientExercise)
                        .background(
                            NavigationLink("", destination: PatientExerciseDetailView(exercise: patientExerciseResponse.exercise, patientExercise: patientExerciseResponse.patientExercise, showStart: false))
                                .opacity(0)
                        )
                        .listRowInsets(EdgeInsets())
                        .listRowBackground(Color.clear)
                        .listRowSeparator(.hidden)
                        .padding(.vertical, 5)
                }
                .onDelete { offsets in
                    viewModel.deletePatientExercise(at: offsets, patientID: patient.id)
                }
            }
            .listStyle(PlainListStyle())
            .refreshable {
                viewModel.fetchPatientExercises(patientID: patient.id)
            }
            
            Spacer()
            
            NavigationLink(destination: AddExerciseView(patient: patient)) {
                Text("Add Exercise")
                    .foregroundStyle(.bright)
            }
            
            
        }
        .frame(maxWidth: .infinity)
        .background(.darkest)
        .onAppear{
            viewModel.fetchPatientExercises(patientID: patient.id)
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    PatientDetailView()
//}
