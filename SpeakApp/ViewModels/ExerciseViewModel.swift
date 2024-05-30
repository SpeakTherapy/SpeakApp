//
//  PatientSignupViewModel.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import Foundation
import Combine

class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var errorMessage: String?
    @Published var creationSuccess: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    func createExercise(title: String, description: String, category: String) {
        let exercise = Exercise(title: title, description: description, category: category)
        APIService.shared.createExercise(exercise: exercise)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { exercise in
                self.exercises.append(exercise)
                self.creationSuccess = true
            })
            .store(in: &self.cancellables)
    }
    
    func fetchExercises() {
        APIService.shared.getExercises()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { exercises in
                self.exercises = exercises
            })
            .store(in: &self.cancellables)
    }
    
    func assignExercise(patientID: UUID, exerciseID: UUID) {
        APIService.shared.assignExercise(patientID: patientID, exerciseID: exerciseID)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                case .finished:
                    break
                }
            }, receiveValue: { response in
                print("Exercise assigned with response: \(response.statusCode)")
            })
            .store(in: &self.cancellables)
    }
}
