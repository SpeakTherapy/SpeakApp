//
//  LoginRequest.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import Foundation

struct LoginRequest: Codable {
    var email: String
    var passwordHash: String
}

struct RegisterRequest: Encodable {
    let name: String
    let email: String
    let passwordHash: String
    let role: String
}

struct LinkRequest: Encodable {
    let referenceCode: String
}
