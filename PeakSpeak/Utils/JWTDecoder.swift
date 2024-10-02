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
