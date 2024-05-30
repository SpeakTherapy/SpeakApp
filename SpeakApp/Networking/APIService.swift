//
//  APIClient.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import Foundation
import Combine

class APIService {
    static let shared = APIService()
    private let baseURL = "http://localhost:8080"
    
    func signup(user: User) -> AnyPublisher<User, Error> {
        let url = URL(string: "\(baseURL)/users/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(user)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func login(request: LoginRequest) -> AnyPublisher<User, Error> {
        let url = URL(string: "\(baseURL)/users/login")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpBody = try? JSONEncoder().encode(request)
        
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .map { $0.data }
            .decode(type: User.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func createExercise(exercise: Exercise) -> AnyPublisher<Exercise, Error> {
        let url = URL(string: "\(baseURL)/exercises")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(exercise)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: Exercise.self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func getExercises() -> AnyPublisher<[Exercise], Error> {
        let url = URL(string: "\(baseURL)/exercises")!
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Exercise].self, decoder: JSONDecoder())
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func assignExercise(patientID: UUID, exerciseID: UUID) -> AnyPublisher<HTTPURLResponse, Error> {
        let url = URL(string: "\(baseURL)/patients/\(patientID)/assign/\(exerciseID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.response as! HTTPURLResponse }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
    
    func linkToTherapist(patientID: UUID, referenceCode: String) -> AnyPublisher<HTTPURLResponse, Error> {
        let url = URL(string: "\(baseURL)/patients/\(patientID)/link")!
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(["referenceCode": referenceCode])
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.response as! HTTPURLResponse }
            .mapError { $0 as Error }
            .eraseToAnyPublisher()
    }
}

