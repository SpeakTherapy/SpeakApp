//
//  LoginRequest.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import Foundation

struct LoginRequest: Codable {
    var email: String
    var password: String
}

struct RegisterRequest: Encodable {
    let name: String
    let email: String
    let password: String
    let role: String
}
