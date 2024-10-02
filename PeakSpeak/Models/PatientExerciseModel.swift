//
//  PatientExerciseModel.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import Foundation

struct PatientExercise: Codable, Identifiable {
    let id: String
    let patientId: String
    let therapistId: String
    let exerciseId: String
    let status: ExerciseStatus
    let recording: String?
    let createdAt: Date
    let updatedAt: Date
    let patientExerciseId: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case patientId = "patient_id"
        case therapistId = "therapist_id"
        case exerciseId = "exercise_id"
        case status
        case recording
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case patientExerciseId = "patient_exercise_id"
    }
}

enum ExerciseStatus: String, Codable {
    case pending
    case completed
}

struct PatientExerciseResponse: Codable, Identifiable {
    let id: String
    let exerciseId: String
    let exercise: Exercise
    let patientExercise: PatientExercise

    enum CodingKeys: String, CodingKey {
        case id
        case exerciseId = "exercise_id"
        case exercise
        case patientExercise = "patient_exercise"
    }
}
