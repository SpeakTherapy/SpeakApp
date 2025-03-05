//
//  NetworkManager.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import Foundation
import Combine
import UIKit

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
//    private let baseURL = "http://localhost:8080"
    private let baseURL = "https://peakspeak-app-xgxwt.ondigitalocean.app"
    
    private var jsonDecoder: JSONDecoder {
        let decoder = JSONDecoder()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        
        let alternateFormatter = DateFormatter()
        alternateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        
        decoder.dateDecodingStrategy = .custom { decoder in
            let container = try decoder.singleValueContainer()
            let dateStr = try container.decode(String.self)
            
            if let date = formatter.date(from: dateStr) {
                return date
            } else if let date = alternateFormatter.date(from: dateStr) {
                return date
            } else {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Date string does not match format expected by formatter.")
            }
        }
        
        return decoder
    }
    
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
    
    func signup(firstName: String, lastName: String, email: String, password: String, role: String) -> AnyPublisher<Result<UserResponse, ErrorResponse>, Never> {
        let url = URL(string: "\(baseURL)/signup")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = createHeaders()

        let body: [String: Any] = ["first_name": firstName, "last_name": lastName, "email": email, "password": password, "role": role]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    let errorResponse = try self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    throw errorResponse
                }
                return output.data
            }
            .map { data in
                do {
                    let signupResponse = try self.jsonDecoder.decode(LoginResponse.self, from: data)
                    saveToken(signupResponse.token) // Store token
                    return .success(signupResponse.user)
                } catch {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: data)
                    return .failure(errorResponse ?? ErrorResponse(error: "Unknown error"))
                }
            }
            .catch { error -> Just<Result<UserResponse, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func getUser(userID: String) -> AnyPublisher<Result<LoginResponse, ErrorResponse>, Never> {
        let url = URL(string: "\(baseURL)/api/user/\(userID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = createHeaders()
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                print("Response: \(output.response)")
                if let jsonString = String(data: output.data, encoding: .utf8) {
                    print("Raw JSON: \(jsonString)")
                }
                guard let response = output.response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }
                
                if response.statusCode == 200 {
                    return output.data
                } else {
                    let errorResponse = try self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    throw errorResponse
                }
            }
            .map { data in
                do {
                    let loginResponse = try self.jsonDecoder.decode(LoginResponse.self, from: data)
                    return .success(loginResponse)
                } catch {
                    print("Decoding LoginResponse error: \(error)")
                    do {
                        let errorResponse = try self.jsonDecoder.decode(ErrorResponse.self, from: data)
                        return .failure(errorResponse)
                    } catch {
                        print("Decoding ErrorResponse error: \(error)")
                        return .failure(ErrorResponse(error: "Unknown error"))
                    }
                }
            }
            .catch { error -> Just<Result<LoginResponse, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func login(email: String, password: String) -> AnyPublisher<Result<UserResponse, ErrorResponse>, Never> {
        let url = URL(string: "\(baseURL)/login")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = createHeaders()

        let body: [String: Any] = ["email": email, "password": password]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    let errorResponse = try self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    throw errorResponse
                }
                return output.data
            }
            .map { data in
                do {
                    let loginResponse = try self.jsonDecoder.decode(LoginResponse.self, from: data)
                    saveToken(loginResponse.token) // Store token
                    return .success(loginResponse.user)
                } catch {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: data)
                    return .failure(errorResponse ?? ErrorResponse(error: "Unknown error"))
                }
            }
            .catch { error -> Just<Result<UserResponse, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func delete(userID: String) -> AnyPublisher<Result<APIResponse, ErrorResponse>, Never> {
        let url = URL(string: "\(baseURL)/api/user/\(userID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.allHTTPHeaderFields = createHeaders()
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                print("Response: \(output.response)")
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    let errorResponse = try self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    throw errorResponse
                }
                return output.data
            }
            .map { data in
                do {
                    let deleteResponse = try self.jsonDecoder.decode(APIResponse.self, from: data)
                    return .success(deleteResponse)
                } catch {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: data)
                    return .failure(errorResponse ?? ErrorResponse(error: "Unknown error"))
                }
            }
            .catch { error -> Just<Result<APIResponse, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func uploadProfilePicture(userID: String, image: UIImage) -> AnyPublisher<Result<UploadProfileResponse, ErrorResponse>, Never> {
        let url = URL(string: "\(baseURL)/api/user/uploadprofile/\(userID)")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        if let token = getToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        
        let imageData = image.jpegData(compressionQuality: 0.5)!
        let body = createBody(boundary: boundary, data: imageData, mimeType: "image/jpeg", filename: "profile.jpg")
        request.httpBody = body
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output -> Data in
                print("Response: \(output.response)")
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
                    let errorResponse = try self.jsonDecoder.decode(ErrorResponse.self, from: output.data)
                    throw errorResponse
                }
                return output.data
            }
            .map { data in
                do {
                    let response = try self.jsonDecoder.decode(UploadProfileResponse.self, from: data)
                    return .success(response)
                } catch {
                    let errorResponse = try? self.jsonDecoder.decode(ErrorResponse.self, from: data)
                    return .failure(errorResponse ?? ErrorResponse(error: "Unknown error"))
                }
            }
            .catch { error -> Just<Result<UploadProfileResponse, ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
    
    func linkToTherapist(userId: String, referenceCode: String) -> AnyPublisher<Result<Void, ErrorResponse>, Never> {
        guard let url = URL(string: "\(baseURL)/api/user/linkToTherapist/\(userId)") else {
            return Just(.failure(ErrorResponse(error: "Invalid URL")))
                .eraseToAnyPublisher()
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.allHTTPHeaderFields = createHeaders()

        let body = ["reference_code": referenceCode]
        request.httpBody = try? JSONEncoder().encode(body)

        return URLSession.shared.dataTaskPublisher(for: request)
            .tryMap { output in
                guard let response = output.response as? HTTPURLResponse, response.statusCode == 200 else {
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
}
