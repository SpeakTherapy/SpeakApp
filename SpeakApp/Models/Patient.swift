//
//  Patient.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import Foundation

struct Patient: Codable {
    var id: UUID?
    var therapistID: UUID
    var referenceCode: String
    var exercises: [Exercise]
}

