//
//  ResponseModel.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import Foundation

struct SimpleResponse: Codable {
    let insertedID: String

    enum CodingKeys: String, CodingKey {
        case insertedID = "InsertedID"
    }
}

struct UploadProfileResponse: Codable {
    let location: String
    let message: String
}

struct UploadResponse: Decodable {
    let uploadURL: String
    
    enum CodingKeys: String, CodingKey {
        case uploadURL = "upload_url"
    }
}

struct DownloadResponse: Decodable {
    let downloadURL: String
    let aesKey: String
    
    enum CodingKeys: String, CodingKey {
        case downloadURL = "download_url"
        case aesKey = "aes_key"
    }
}

struct ErrorResponse: Codable, Error {
    let error: String
}

struct LoginResponse: Codable {
    let token: String
    let user: UserResponse
}

struct UserResponse: Codable {
    let id: String
    let firstName: String
    let lastName: String
    let email: String
    let password: String
    let role: String
    let referenceCode: String?
    let profileImage: String?
    let createdAt: Date
    let updatedAt: Date
    let userId: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case firstName = "first_name"
        case lastName = "last_name"
        case email
        case password
        case role
        case referenceCode = "reference_code"
        case profileImage = "profile_image"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case userId = "user_id"
    }
}

struct TokenResponse: Codable {
    let token: String
    let refreshToken: String
    
    enum CodingKeys: String, CodingKey {
        case token
        case refreshToken = "refresh_token"
    }
}

struct APIResponse: Codable {
    let message: String?
}


