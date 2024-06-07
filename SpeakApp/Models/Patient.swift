//
//  Patient.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import Foundation

struct Patient: Codable, Identifiable {
    var id: UUID?
    var therapistID: UUID
    var userID: UUID
    var referenceCode: String
    var exercises: [Exercise]
    var user: User
    var therapist: User?
}

