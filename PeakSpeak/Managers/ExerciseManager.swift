//
//  ExerciseManager.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/23/24.
//

import Foundation
import Combine

class ExerciseManager {
    static let shared = ExerciseManager()
    private init() {}
    
//    private let baseURL = "http://localhost:8080"
    private let baseURL = "https://peakspeak-app-xgxwt.ondigitalocean.app"
    
    let jsonDecoder: JSONDecoder = {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        decoder.dateDecodingStrategy = .formatted(formatter)
        return decoder
    }()
    
    private func createBody(boundary: String, data: Data, mimeType: String, filename: String) -> Data {
        var body = Data()
        
        body.append("--\(boundary)\r\n")
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"\(filename)\"\r\n")
        body.append("Content-Type: \(mimeType)\r\n\r\n")
        body.append(data)
        body.append("\r\n")
        body.append("--\(boundary)--\r\n")
        
        return body
    }
    
    
    func getGlobalExercises() -> AnyPublisher<Result<ExerciseResponse, ErrorResponse>, Never> {
        guard let url = URL(string: "\(baseURL)/api/exercises/exercises") else {
            return Just(.failure(ErrorResponse(error: "Invalid URL")))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = createHeaders()
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                print("Output: ", output)
                guard let response = output.response as? HTTPURLResponse else {
                    print("Invalid response")
                    throw ErrorResponse(error: "Invalid response")
                }
                guard response.statusCode == 200 else {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    print("Error Response: ", errorResponse ?? "Unknown error")
                    throw errorResponse ?? ErrorResponse(error: "Unknown error")
                }
                do {
                    let exerciseResponse = try self.jsonDecoder.decode(ExerciseResponse.self, from: output.data)
                    print("ExerciseResponse: ", exerciseResponse)
                    return .success(exerciseResponse)
                } catch {
                    print("Decoding error: ", error)
                    throw error
                }
            }
            .catch { error -> Just<Result<ExerciseResponse, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                print("Caught error: ", errorResponse)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getTherapistExercises(therapistID: String) -> AnyPublisher<Result<ExerciseResponse, ErrorResponse>, Never> {
        // Build the URL with query parameter for therapist_id
//        guard let url = URL(string: "\(baseURL)/api/exercises/therapist?therapist_id=\(therapistID)") else {
//            return Just(.failure(ErrorResponse(error: "Invalid URL")))
//                .eraseToAnyPublisher()
//        }
        guard let encodedTherapistID = therapistID.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "\(baseURL)/api/exercises/therapist?therapist_id=\(encodedTherapistID)") else {
            return Just(.failure(ErrorResponse(error: "Invalid URL")))
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = createHeaders()
        
        print("Fetching therapist exercises from URL: \(url.absoluteString)") // Debug log
            
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    throw errorResponse ?? ErrorResponse(error: "Unknown error")
                }
                // Print raw JSON for debugging:
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("Therapist Exercises JSON: \(jsonString)")
                }
                let exerciseResponse = try self.jsonDecoder.decode(ExerciseResponse.self, from: output.data)
                return .success(exerciseResponse)
            }
            .catch { error -> Just<Result<ExerciseResponse, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    
    func createExercise(name: String, description: String, videoURL: String, tags: [String], isGlobal: Bool, therapistID: String) -> AnyPublisher<Result<SimpleResponse, ErrorResponse>, Never> {
        let url = URL(string: "\(baseURL)/api/exercise")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = createHeaders()
        
        let body: [String: Any] = ["name": name, "description": description, "tags": tags, "video_url": videoURL, "is_global": isGlobal, "therapist_id": therapistID]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap{ output -> Data in
                print("Response: \(output.response)")
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    let errorResponse = try self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    throw errorResponse
                }
                return output.data
            }
            .map { data in
                do {
                    let createExerciseResponse = try self.jsonDecoder.decode(SimpleResponse.self, from: data)
                    return .success(createExerciseResponse)
                } catch {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: data)
                    return .failure(errorResponse ?? ErrorResponse(error: "Unknown error"))
                }
            }
            .catch { error -> Just<Result<SimpleResponse, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func assignExercisesToPatient(patientID: String, therapistID: String, exerciseIDs: [String]) -> AnyPublisher<Result<Void, ErrorResponse>, Never> {
        guard let url = URL(string: "\(baseURL)/api/patientexercise") else {
            return Just(.failure(ErrorResponse(error: "Invalid URL")))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = createHeaders()
        
        let body: [String: Any] = [
            "patient_id": patientID,
            "therapist_id": therapistID,
            "exercise_ids": exerciseIDs
        ]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw ErrorResponse(error: "Invalid response")
                }
                guard response.statusCode == 200 else {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    throw errorResponse ?? ErrorResponse(error: "Unknown error")
                }
                return .success(())
            }
            .catch { error -> Just<Result<Void, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getPatientExercises(patientID: String) -> AnyPublisher<Result<[PatientExerciseResponse], ErrorResponse>, Never> {
        guard let url = URL(string: "\(baseURL)/api/patientexercises/\(patientID)") else {
            return Just(.failure(ErrorResponse(error: "Invalid URL")))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = createHeaders()
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                print("Output: ", output)
                guard let response = output.response as? HTTPURLResponse else {
                    print("Invalid response")
                    throw ErrorResponse(error: "Invalid response")
                }
                guard response.statusCode == 200 else {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    print("Error Response: ", errorResponse ?? "Unknown error")
                    throw errorResponse ?? ErrorResponse(error: "Unknown error")
                }
                do {
                    let exerciseResponses = try self.jsonDecoder.decode([PatientExerciseResponse].self, from: output.data)
                    print("ExerciseResponse: ", exerciseResponses)
                    return .success(exerciseResponses)
                } catch {
                    print("Decoding error: ", error)
                    throw error
                }
            }
            .catch { error -> Just<Result<[PatientExerciseResponse], ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                print("Caught error: ", errorResponse)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func deletePatientExercise(patientExerciseID: String) -> AnyPublisher<Result<Void, ErrorResponse>, Never> {
        guard let url = URL(string: "\(baseURL)/api/patientexercise/\(patientExerciseID)") else {
            return Just(.failure(ErrorResponse(error: "Invalid URL")))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = createHeaders()
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse else {
                    throw ErrorResponse(error: "Invalid response")
                }
                guard response.statusCode == 200 else {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    throw errorResponse ?? ErrorResponse(error: "Unknown error")
                }
                return .success(())
            }
            .catch { error -> Just<Result<Void, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getUploadURL(patientExerciseID: String, aesKey: String) -> AnyPublisher<UploadResponse, Error> {
        let url = URL(string: "\(baseURL)/api/getuploadurl/\(patientExerciseID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = createHeaders()
        
        let requestBody: [String: String] = ["aes_key": aesKey]
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: requestBody, options: [])
        } catch {
            return Fail(error: error)
                .eraseToAnyPublisher()
        }
        
        // Perform the network request on a background thread
        return URLSession.shared.dataTaskPublisher(for: request)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .tryMap { data, response -> UploadResponse in
                // Check for HTTP errors
                if let httpResponse = response as? HTTPURLResponse, !(200...299).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }
                
                // Decode the JSON response into an UploadInfo object
                return try JSONDecoder().decode(UploadResponse.self, from: data)
            }
            .receive(on: DispatchQueue.main) // Ensure the result is delivered on the main thread
            .eraseToAnyPublisher()
    }
    
    func getDownloadURL(patientExerciseID: String) -> AnyPublisher<DownloadResponse, Error> {
        let url = URL(string: "\(baseURL)/api/getdownloadurl/\(patientExerciseID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = createHeaders()
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { data, response -> DownloadResponse in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return try JSONDecoder().decode(DownloadResponse.self, from: data)
            }
            .eraseToAnyPublisher()
    }
    
    func downloadVideo(from urlString: String) -> AnyPublisher<Data, Error> {
        guard let url = URL(string: urlString) else {
            return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
        }
        
        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response -> Data in
                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                    throw URLError(.badServerResponse)
                }
                return data
            }
            .eraseToAnyPublisher()
    }
}
