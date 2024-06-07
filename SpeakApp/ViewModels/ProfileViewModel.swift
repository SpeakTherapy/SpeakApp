//
//  ProfileViewModel.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/30/24.
//

import Foundation
import Combine

class ProfileViewModel: ObservableObject {
    @Published var therapistName: String = ""
    @Published var therapistReferenceCode: String = ""
    @Published var isLinkedToTherapist: Bool = false
    @Published var showingAlert: Bool = false
    @Published var alertMessage: String = ""
    @Published var user: User?
    
    private var cancellables = Set<AnyCancellable>()
    
    func fetchSelf(userID: UUID) {
        APIService.shared.getUser(userID: userID)
            .receive(on: DispatchQueue.main) // Ensure updates are received on the main thread
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                }
            }, receiveValue: { user in
                self.user = user
                if user.referenceCode != nil {
                    self.getTherapist(referenceCode: user.referenceCode!)
                    self.isLinkedToTherapist = true
                }
            })
            .store(in: &cancellables)
    }
    
    func getTherapist(referenceCode: String) {
        APIService.shared.getTherapist(referenceCode: referenceCode)
            .receive(on: DispatchQueue.main) // Ensure updates are received on the main thread
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    self.alertMessage = error.localizedDescription
                    self.showingAlert = true
                }
            }, receiveValue: { user in
                self.therapistName = user.name
            })
            .store(in: &cancellables)
    }
    
    func linkToTherapist(user: User) {
        APIService.shared.linkToTherapist(userID: user.id!, referenceCode: therapistReferenceCode)
            .receive(on: DispatchQueue.main) // Ensure updates are received on the main thread
            .sink(receiveCompletion: { completion in
                switch completion {
                case .finished:
                    self.alertMessage = "Successfully linked to therapist."
                    self.fetchSelf(userID: user.id!)
                case .failure(let error):
                    self.alertMessage = "Failed to link to therapist: \(error.localizedDescription)"
                }
                self.showingAlert = true
            }, receiveValue: { _ in })
            .store(in: &cancellables)
    }
}
