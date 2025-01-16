//
//  ExerciseModel.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import Foundation

struct Exercise: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    let videoURL: String?
    let tags: [ExerciseTags]
    let createdAt: Date
    let updatedAt: Date
    let exerciseId: String
    let isGlobal: Bool
    let therapistID: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name
        case description
        case videoURL = "video_url"
        case tags = "tags"
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case exerciseId = "exercise_id"
        case isGlobal = "is_global"
        case therapistID = "therapist_id"
    }
}

struct ExerciseResponse: Codable {
    let exercises: [Exercise]
    let total: Int
}

enum ExerciseFilter: String, CaseIterable, Identifiable {
    case global = "Global"
    case therapist = "Private" // 'private' is a reserved keyword in Swift
    
    var id: String { self.rawValue }
}

enum ExerciseTags: String, Codable, CaseIterable, Identifiable {
    case articulation
    case stuttering
    case comprehension
    case audio
    case vocal

    var id: Self { self }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self).lowercased()
        guard let value = ExerciseTags(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid tag value: \(rawValue)")
        }
        self = value
    }
}

