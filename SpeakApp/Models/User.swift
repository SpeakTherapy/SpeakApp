//
//  User.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/26/24.
//

import Foundation

struct User: Codable, Identifiable {
    var id: UUID?
    var name: String
    var email: String
    var passwordHash: String
    var role: UserRole
    var referenceCode: String?
}

enum UserRole: String, Codable {
    case therapist
    case patient
}

// therapist003265
