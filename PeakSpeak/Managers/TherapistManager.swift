//
//  TherapistManager.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/25/24.
//

import Foundation
import Combine

class TherapistManager {
    static let shared = TherapistManager()
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
    
    
    func getPatients(therapistID: String) -> AnyPublisher<Result<[User], ErrorResponse>, Never> {
        guard let url = URL(string: "\(baseURL)/patients/\(therapistID)") else {
            return Just(.failure(ErrorResponse(error: "Invalid URL")))
                .eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
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
                    let patientResponse = try self.jsonDecoder.decode([User].self, from: output.data)
                    print("Patient Response: ", patientResponse)
                    return .success(patientResponse)
                } catch {
                    print("Decoding error: ", error)
                    throw error
                }
            }
            .catch { error -> Just<Result<[User], ErrorResponse>> in
                let errorResponse = error as? ErrorResponse ?? ErrorResponse(error: error.localizedDescription)
                print("Caught error: ", errorResponse)
                return Just(.failure(errorResponse))
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
