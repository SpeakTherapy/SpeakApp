//
//  ExerciseViewModel.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/23/24.
//

import Foundation
import Combine
import CryptoKit
import AVFoundation

class ExerciseViewModel: ObservableObject {
    @Published var exercises: [Exercise] = []
    @Published var allExercises: [Exercise] = []
    @Published var globalExercises: [Exercise] = []
    @Published var therapistExercises: [Exercise] = []
    @Published var selectedExercises: Set<String> = []
    @Published var patientExercises: [PatientExerciseResponse] = []
    @Published var fetchError: String?
    @Published var createError: String?
    @Published var uploadError: String?
    @Published var downloadError: String?
    @Published var creationSuccess: Bool = false
    @Published var videoPlayer: AVPlayer?
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()
    private var uploadURL: String?
    private var encryptedData: Data?
    
    init() {
        if AuthManager.shared.user?.role == .therapist {
            fetchGlobalExercises()
        } else if AuthManager.shared.user?.role == .patient{
            fetchPatientExercises(patientID: AuthManager.shared.user!.userId)
        }
    }
    
    func fetchAllExercises(therapistID: String) {
        // 1. Fetch global
        // 2. Fetch therapist
        // 3. Combine them
        Publishers.Zip(
            ExerciseManager.shared.getGlobalExercises(),
            ExerciseManager.shared.getTherapistExercises(therapistID: therapistID)
        )
        .receive(on: DispatchQueue.main)
        .sink { [weak self] globalResult, therapistResult in
            switch globalResult {
            case .success(let globalResponse):
                switch therapistResult {
                case .success(let therapistResponse):
                    // Combine them
                    let combined = globalResponse.exercises + therapistResponse.exercises
                    self?.allExercises = combined
                case .failure(let error):
                    self?.fetchError = error.error
                }
            case .failure(let error):
                self?.fetchError = error.error
            }
        }
        .store(in: &cancellables)
    }

    func fetchGlobalExercises() {
        ExerciseManager.shared.getGlobalExercises()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let exerciseResponse):
                    self?.globalExercises = exerciseResponse.exercises
                    self?.exercises = exerciseResponse.exercises
                    self?.fetchError = nil
                case .failure(let error):
                    self?.fetchError = error.error
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchTherapistExercises(therapistID: String) {
        ExerciseManager.shared.getTherapistExercises(therapistID: therapistID)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success(let exerciseResponse):
                    print("Therapist exercises fetched: \(exerciseResponse.exercises)")
                    self?.therapistExercises = exerciseResponse.exercises
                    self?.exercises = exerciseResponse.exercises
                    self?.fetchError = nil
                case .failure(let error):
                    print("Error fetching therapist exercises: \(error.error)")
                    self?.fetchError = error.error
                }
            }
            .store(in: &cancellables)
    }
    
    func createExercise(name: String, description: String, tags: [String], videoURL: String?, isGlobal: Bool) {
        guard let therapistID = AuthManager.shared.user?.id else {
            self.createError = "No user found"
            return
        }
        ExerciseManager.shared.createExercise(name: name, description: description, videoURL: videoURL ?? "", tags: tags, isGlobal: isGlobal, therapistID: therapistID)
            .receive(on: DispatchQueue.main)
            .sink{ [weak self] result in
                switch result {
                case .success(let response):
                    print("Exercise created with ID: \(response.insertedID)")
                    self?.fetchError = nil
                    self?.creationSuccess = true
                case .failure(let error):
                    print("Create Exercise error: \(error.error)")
                    self?.createError = error.error
                }
            }
            .store(in: &cancellables)
    }
    
    func assignExercisesToPatient(patientID: String) {
        guard let therapistID = AuthManager.shared.user?.id else {
            self.createError = "No user found"
            return
        }
        let exerciseIDs = Array(selectedExercises)
        ExerciseManager.shared.assignExercisesToPatient(patientID: patientID, therapistID: therapistID, exerciseIDs: exerciseIDs)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] result in
                switch result {
                case .success:
                    self?.creationSuccess = true
                    self?.createError = nil
                case .failure(let error):
                    self?.creationSuccess = false
                    self?.createError = error.error
                }
            }
            .store(in: &cancellables)
    }
    
    func fetchPatientExercises(patientID: String) {
        ExerciseManager.shared.getPatientExercises(patientID: patientID)
            .receive(on: DispatchQueue.main) // Ensure updates happen on the main thread
            .sink { completion in
                switch completion {
                case .failure(let error):
                    print("Failed to fetch exercises: \(error.localizedDescription)")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] result in
                switch result {
                case .success(let exercises):
                    self?.patientExercises = exercises
                case .failure(let error):
                    print("Error fetching exercises: \(error)")
                }
            }
            .store(in: &cancellables)
    }

    
    func deletePatientExercise(at offsets: IndexSet, patientID: String) {
        offsets.forEach { index in
            let exerciseToDelete = patientExercises[index]
            ExerciseManager.shared.deletePatientExercise(patientExerciseID: exerciseToDelete.id)
                .receive(on: DispatchQueue.main)
                .sink { [weak self] result in
                    switch result {
                    case .success:
                        self?.patientExercises.remove(at: index)
                    case .failure(let error):
                        self?.fetchError = error.error
                    }
                }
                .store(in: &cancellables)
        }
    }
    
    func uploadRecording(patientExerciseID: String, videoURL: URL, completionHandler: @escaping () -> Void) {
        guard (AuthManager.shared.user?.userId) != nil else { return }

        // Generate AES key
        let aesKey = SymmetricKey(size: .bits256)
        let keyData = aesKey.withUnsafeBytes { Data(Array($0)) }
        let keyBase64 = keyData.base64EncodedString()

        // Encrypt the video
        guard let encryptedData = encryptVideo(videoURL: videoURL, key: aesKey) else {
            print("Failed to read or encrypt video file")
            return
        }
        print("Finished encrypting video")

        // Get signed URL from backend and upload encrypted video
        ExerciseManager.shared.getUploadURL(patientExerciseID: patientExerciseID, aesKey: keyBase64)
            .flatMap { [weak self] uploadResponse -> AnyPublisher<URL, Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
                }
                
                // Convert the upload URL string to a URL
                guard let uploadURL = URL(string: uploadResponse.uploadURL) else {
                    return Fail(error: URLError(.badURL)).eraseToAnyPublisher()
                }
                
                return self.uploadEncryptedVideo(encryptedData: encryptedData, to: uploadURL)
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                switch completion {
                case .failure(let error):
                    self.uploadError = error.localizedDescription
                    print("Failed to upload video: \(error.localizedDescription)")
                case .finished:
                    completionHandler()  // Call the completion handler on success
                }
            }, receiveValue: { url in
                print("Video uploaded successfully: \(url)")
            })
            .store(in: &cancellables)
    }
    
    func loadVideo(patientExerciseID: String) {
        isLoading = true
        downloadError = nil
        
        ExerciseManager.shared.getDownloadURL(patientExerciseID: patientExerciseID)
            .flatMap { [weak self] response -> AnyPublisher<Data, Error> in
                guard let self = self else {
                    return Fail(error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Self is nil"])).eraseToAnyPublisher()
                }
                
                return ExerciseManager.shared.downloadVideo(from: response.downloadURL)
                    .tryMap { encryptedData in
                        guard let keyData = Data(base64Encoded: response.aesKey) else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decrypt video"])
                        }
                        let key = SymmetricKey(data: keyData)
                        
                        // Decrypt the video
                        guard let decryptedData = self.decryptVideo(data: encryptedData, key: key) else {
                            throw NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to decrypt video"])
                        }
                        return decryptedData
                    }
                    .eraseToAnyPublisher()
            }
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.downloadError = error.localizedDescription
                }
            }, receiveValue: { [weak self] decryptedData in
                self?.saveAndPlayVideo(data: decryptedData)
            })
            .store(in: &cancellables)
    }

    private func encryptVideo(videoURL: URL, key: SymmetricKey) -> Data? {
        do {
            let videoData = try Data(contentsOf: videoURL)
            let sealedBox = try AES.GCM.seal(videoData, using: key)
            return sealedBox.combined
        } catch {
            print("Failed to encrypt video data: \(error)")
            return nil
        }
    }
    
    private func decryptVideo(data: Data, key: SymmetricKey) -> Data? {
        do {
            let sealedBox = try AES.GCM.SealedBox(combined: data)
            let decryptedData = try AES.GCM.open(sealedBox, using: key)
            return decryptedData
        } catch {
            print("Failed to decrypt video: \(error)")
            return nil
        }
    }
    
    private func uploadEncryptedVideo(encryptedData: Data, to url: URL) -> AnyPublisher<URL, Error> {
        return AWSS3Uploader.upload(data: encryptedData, toPresignedURL: url)
            .map { $0 }
            .eraseToAnyPublisher()
    }
    
    private func saveAndPlayVideo(data: Data) {
        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent("decrypted_video.mp4")
        do {
            try data.write(to: tempURL)
            self.videoPlayer = AVPlayer(url: tempURL)
        } catch {
            self.downloadError = "Failed to save video: \(error.localizedDescription)"
        }
    }
}
