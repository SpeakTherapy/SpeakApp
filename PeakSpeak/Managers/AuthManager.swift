//
//  AuthService.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import Foundation
import Combine
import UIKit

class AuthManager: ObservableObject {
    static let shared = AuthManager()
    @Published var user: User?
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    @Published var role: UserRole = .patient
    @Published var signupError: String?
    @Published var loginError: String?
    @Published var deleteError: String?
    @Published var linkError: String?
    @Published var fetchError: String?
    @Published var uploadError: String?
    @Published var isAuthenticated = false
    private var cancellables = Set<AnyCancellable>()
    private let userDefaults = UserDefaults.standard
    
    private var refreshTimer: AnyCancellable?
    private var isRefreshingToken = false
    
    init() {
        loadUserFromStorage()
    }
    
    func signup(firstName: String, lastName: String, email: String, password: String, role: String) {
        NetworkManager.shared.signup(firstName: firstName, lastName: lastName, email: email, password: password, role: role)
            .sink { [weak self] result in
                switch result {
                case .success(let response):
                    print("User signed up with ID: \(response.insertedID)")
                    self?.signupError = nil
                    self?.login(email: email, password: password)
                case .failure(let error):
                    print("Signup error: \(error.error)")
                    self?.signupError = error.error
                }
            }
            .store(in: &cancellables)
    }
    
    func login(email: String, password: String) {
        
        NetworkManager.shared.login(email: email, password: password)
            .sink { [weak self] result in
                switch result {
                case .success(let response):
                    self?.user = User(id: response.id, firstName: response.firstName, lastName: response.lastName, email: response.email, password: response.password, role: UserRole(rawValue: response.role)!, referenceCode: response.referenceCode ?? "", profileImage: response.profileImage ?? "", token: response.token, refreshToken: response.refreshToken, createdAt: response.createdAt, updatedAt: response.updatedAt, userId: response.userId)
                    self?.loginError = nil
                    self?.isAuthenticated = true
                    
                    self?.saveUserToStorage()
                    
                    print("User logged in: \(response.email)")
                case .failure(let error):
                    print("Login error: \(error.error)")
                    self?.loginError = error.error
                }
            }
            .store(in: &cancellables)
    }
    
    func logout() {
        self.user = nil
        self.isAuthenticated = false
        clearUserFromStorage()
    }
    
    func deleteUser(completion: @escaping (Bool) -> Void) {
        guard let userId = user?.userId else { return }
        
        NetworkManager.shared.delete(userID: userId)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.deleteError = nil
                    print("Deleted user successfully")
                    self?.logout()
                    completion(true)
                case .failure(let error):
                    print("Delete error: \(error.error)")
                    self?.deleteError = error.error
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
    
    func linkToTherapist(referenceCode: String) {
        guard let userId = user?.userId else { return }
        
        NetworkManager.shared.linkToTherapist(userId: userId, referenceCode: referenceCode)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.linkError = nil
                    self?.user?.referenceCode = referenceCode
                    print("Linked to therapist successfully")
                    self?.saveUserToStorage()
                    self?.objectWillChange.send()
                case .failure(let error):
                    print("Linking error: \(error.error)")
                    self?.linkError = error.error
                }
            }
            .store(in: &cancellables)
    }
    
    func uploadProfilePicture(image: UIImage) {
        guard let userId = user?.userId else { return }
        
        NetworkManager.shared.uploadProfilePicture(userID: userId, image: image)
            .sink { [weak self] result in
                switch result {
                case .success(let response):
                    self?.uploadError = nil
                    self?.user?.profileImage = response.location
                    self?.saveUserToStorage()
                    self?.objectWillChange.send()
                case .failure(let error):
                    print("Upload error: \(error.error)")
                    self?.uploadError = error.error
                }
            }
            .store(in: &cancellables)
    }
    
    private func saveUserToStorage() {
        guard let user = user else { return }
        do {
            // Save non-sensitive user data to UserDefaults
            var userCopy = user
            userCopy.token = nil
            userCopy.refreshToken = nil
            let userData = try JSONEncoder().encode(userCopy)
            userDefaults.set(userData, forKey: "peakspeak-user")
            print("User saved to UserDefaults: \(userCopy)")
            
            // Verify the data type
            if let savedData = userDefaults.data(forKey: "peakspeak-user") {
                print("Data saved in UserDefaults as Data type: \(savedData)")
            } else {
                print("Failed to save data correctly in UserDefaults")
            }

        } catch {
            print("Failed to save user to storage: \(error)")
        }
    }

    private func loadUserFromStorage() {
        print("Got to loading user")
        
        if let userData = userDefaults.data(forKey: "peakspeak-user") {
            print("User data found in UserDefaults")
            do {
                let user = try JSONDecoder().decode(User.self, from: userData)
                self.user = user
            
                self.user = user
            } catch {
                print("Failed to load user from storage: \(error)")
            }
        } else {
            print("No user data found in UserDefaults")
        }
    }

    private func clearUserFromStorage() {
        userDefaults.removeObject(forKey: "peakspeak-user")
    }
    
}
