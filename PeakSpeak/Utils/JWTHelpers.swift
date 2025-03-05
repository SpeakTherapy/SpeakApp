//
//  JWTDecoder.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/23/24.
//

import Foundation

struct JWTDecoder {
    static func decode(jwtToken jwt: String) -> [String: Any]? {
        let segments = jwt.split(separator: ".")
        guard segments.count == 3 else { return nil }
        
        let base64String = String(segments[1])
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        guard let data = Data(base64Encoded: base64String, options: .ignoreUnknownCharacters),
              let json = try? JSONSerialization.jsonObject(with: data, options: []),
              let payload = json as? [String: Any] else { return nil }
        
        return payload
    }
}

extension Date {
    static func fromUnixTimestamp(_ timestamp: Double) -> Date {
        return Date(timeIntervalSince1970: timestamp)
    }
}

let tokenKey = "peakspeak-token"

// Function to Retrieve Token from UserDefaults
func getToken() -> String? {
    return UserDefaults.standard.string(forKey: tokenKey)
}

// Function to Save Token to UserDefaults
func saveToken(_ token: String) {
    UserDefaults.standard.set(token, forKey: tokenKey)
}

// Function to Remove Token from UserDefaults (for Logout)
func clearToken() {
    UserDefaults.standard.removeObject(forKey: tokenKey)
}

// Function to Create JSON Headers with Authorization
func createHeaders() -> [String: String] {
    var headers = ["Content-Type": "application/json"]
    if let token = getToken() {
        headers["Authorization"] = "Bearer \(token)"
    }
    return headers
}
