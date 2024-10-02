//
//  DataExtension.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/30/24.
//

import Foundation

extension Data {
    mutating func append(_ string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
