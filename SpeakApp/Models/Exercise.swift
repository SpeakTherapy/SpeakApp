//
//  Therapist.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import Foundation

struct Exercise: Codable, Identifiable {
    var id: UUID?
    var title: String
    var description: String
    var category: String
}
