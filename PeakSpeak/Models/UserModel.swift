//
//  UserModel.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import Foundation

struct User: Codable, Identifiable {
    var id: String
    var firstName: String
    var lastName: String
    var email: String
    var password: String?
    var role: UserRole
    var referenceCode: String
    var profileImage: String?
    var token: String?
    var refreshToken: String?
    var createdAt: Date
    var updatedAt: Date
    var userId: String
    
    enum CodingKeys: String, CodingKey {
        case id = "id"
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case role
        case referenceCode = "reference_code"
        case profileImage = "profile_image"
        case token
        case refreshToken = "refresh_token"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
}

enum UserRole: String, Codable, CaseIterable, Identifiable {
    case patient
    case therapist
    
    var id: Self { self }
}

struct PatientResponse: Codable {
    let patients: [User]
}
