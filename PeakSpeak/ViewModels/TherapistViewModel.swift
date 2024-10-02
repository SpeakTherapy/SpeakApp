//
//  TherapistViewModel.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/25/24.
//

import Foundation
import Combine

class TherapistViewModel: ObservableObject {
    @Published var patients: [User] = []
    @Published var fetchError: String?
    @Published var createError: String?
    @Published var creationSuccess: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        print("Inside therapistViewModel")
        if AuthManager.shared.user?.role == .therapist {
            print("role is therapist")
            fetchPatients()
        }
    }

    func fetchPatients() {
        print("just inside fetch patients")
        guard let user = AuthManager.shared.user else {
            self.fetchError = "No user found"
            return
        }
        if user.role != .therapist {
            self.fetchError = "Role must be therapist"
            return
        }

        print("fetching patients")
        TherapistManager.shared.getPatients(therapistID: user.userId )
            .sink { [weak self] result in
                switch result {
                case .success(let patients):
                    print("fetch was success")
                    self?.patients = patients
                case .failure(let error):
                    print("couldn't fetch")
                    self?.fetchError = error.error
                }
            }
            .store(in: &cancellables)
    }
}
