//
//  LoginViewModel.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import Foundation
import Combine

class AuthViewModel: ObservableObject {
    @Published var user: User?
    @Published var errorMessage: String?
    private var cancellables = Set<AnyCancellable>()
    
    func signup(name: String, email: String, password: String, role: UserRole) {
        let user = User(name: name, email: email, passwordHash: password, role: role, referenceCode: "")
        APIService.shared.signup(user: user)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { user in
                self.user = user
            })
            .store(in: &self.cancellables)
    }
    
    func login(email: String, password: String) {
        let request = LoginRequest(email: email, passwordHash: password)
        APIService.shared.login(request: request)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { user in
                self.user = user
            })
            .store(in: &self.cancellables)
    }
}
