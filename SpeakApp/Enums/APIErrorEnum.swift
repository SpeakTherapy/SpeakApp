//
//  APIErrorEnum.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/23/24.
//

import Foundation

enum APIError: Error {
    case encodingFailed
    case invalidResponse
    case serverError(Error)
}
