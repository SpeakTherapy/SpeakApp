//
//  PatientListView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/25/24.
//

import SwiftUI

struct TherapistView: View {
    @EnvironmentObject var authManager: AuthManager
    @StateObject private var viewModel = TherapistViewModel()
    
    var body: some View {
        VStack {
            
            ScrollView {
                LazyVStack {
                    if !viewModel.patients.isEmpty {
                        ForEach(viewModel.patients) { patient in
                            NavigationLink(destination: PatientDetailView(patient: patient)) {
                                PatientCard(patient: patient)
                                    .padding(.bottom, 10)
                            }
                        }
                    } else {
                        Text("No Patients Found")
                    }
                }
            }
            Spacer()
            
        }
        .background(.darkest)
        .navigationTitle("Therapist")
        .refreshable {
            print("trying to refresh here")
            viewModel.fetchPatients()
        }
    }
}

//#Preview {
//    PatientListView()
//}
