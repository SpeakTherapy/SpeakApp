//
//  AWSS3Uploader.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 8/8/24.
//

import Foundation
import Combine

class AWSS3Uploader {
    
    /// Creates an upload request for uploading the specified data to a presigned remote URL
    ///
    /// - Parameters:
    ///     - data: The data to upload.
    ///     - remoteURL: The presigned URL
    /// - Returns: A publisher that emits the result of the upload.
    
    class func upload(data: Data, toPresignedURL remoteURL: URL) -> AnyPublisher<URL, Error> {
        var request = URLRequest(url: remoteURL)
        request.cachePolicy = .reloadIgnoringLocalCacheData
        request.httpMethod = "PUT"
        request.setValue("application/octet-stream", forHTTPHeaderField: "Content-Type")
        
        #if DEBUG
        print("Starting upload to: \(remoteURL)")
        print("Data size: \(data.count) bytes")
        #endif
        
        return Future<URL, Error> { promise in
            let uploadTask = URLSession.shared.uploadTask(with: request, from: data) { data, response, error in
                if let error = error {
                    #if DEBUG
                    print("Upload task error: \(error)")
                    #endif
                    promise(.failure(error))
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                    let error = URLError(.badServerResponse)
                    #if DEBUG
                    print("Upload task failed due to invalid response")
                    #endif
                    promise(.failure(error))
                    return
                }
                
                if (200...299).contains(response.statusCode) {
                    #if DEBUG
                    print("Upload task succeeded with status code: \(response.statusCode)")
                    #endif
                    promise(.success(remoteURL))
                } else {
                    let error = NSError(domain: "", code: response.statusCode, userInfo: [NSLocalizedDescriptionKey: "Failed to upload video, status code: \(response.statusCode)"])
                    if let data = data, let responseBody = String(data: data, encoding: .utf8) {
                        #if DEBUG
                        print("Response body: \(responseBody)")
                        #endif
                    }
                    promise(.failure(error))
                }
            }
            uploadTask.resume()
        }
        .eraseToAnyPublisher()
    }
}
