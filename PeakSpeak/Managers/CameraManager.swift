//
//  CameraManager.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/30/24.
//

import Foundation
import AVFoundation

class CameraManager: NSObject, ObservableObject {
    @Published var isConfigured = false
    var captureSession: AVCaptureSession?
    private var videoOutput: AVCaptureMovieFileOutput?
    private var videoCompletionHandler: ((URL?) -> Void)?

    func configure() {
        let session = AVCaptureSession()
        
        do {
            // Configure Video Input
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                throw CameraError.cameraUnavailable
            }
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            guard session.canAddInput(videoDeviceInput) else {
                throw CameraError.cannotAddInput
            }
            session.addInput(videoDeviceInput)
            
            // Configure Audio Input
            guard let audioDevice = AVCaptureDevice.default(for: .audio) else {
                throw CameraError.cameraUnavailable
            }
            let audioDeviceInput = try AVCaptureDeviceInput(device: audioDevice)
            guard session.canAddInput(audioDeviceInput) else {
                throw CameraError.cannotAddInput
            }
            session.addInput(audioDeviceInput)
            
            // Configure Video Output
            let videoOutput = AVCaptureMovieFileOutput()
            guard session.canAddOutput(videoOutput) else {
                throw CameraError.cannotAddOutput
            }
            session.addOutput(videoOutput)
            self.captureSession = session
            self.videoOutput = videoOutput
            isConfigured = true
            session.startRunning()
        } catch {
            print("Error configuring camera: \(error.localizedDescription)")
        }
    }

    func startRecording(completion: @escaping (URL?) -> Void) {
        guard let captureSession = captureSession, let videoOutput = videoOutput else { return }
        
        DispatchQueue.global(qos: .userInitiated).async {
            if !captureSession.isRunning {
                captureSession.startRunning()
            }
            
            let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString + ".mp4")
            videoOutput.startRecording(to: outputURL, recordingDelegate: self)
            DispatchQueue.main.async {
                self.videoCompletionHandler = completion
            }
        }
    }

    func stopRecording() {
        DispatchQueue.global(qos: .userInitiated).async {
            self.videoOutput?.stopRecording()
            self.captureSession?.stopRunning()
        }
    }
}

extension CameraManager: AVCaptureFileOutputRecordingDelegate {
    func fileOutput(_ output: AVCaptureFileOutput, didFinishRecordingTo outputFileURL: URL, from connections: [AVCaptureConnection], error: Error?) {
        DispatchQueue.main.async {
            if let error = error {
                print("Error recording video: \(error)")
                self.videoCompletionHandler?(nil)
            } else {
                self.videoCompletionHandler?(outputFileURL)
            }
            self.videoCompletionHandler = nil
        }
    }
}


enum CameraError: Error {
  case cameraUnavailable
  case cannotAddInput
  case cannotAddOutput
  case createCaptureInput(Error)
  case deniedAuthorization
  case restrictedAuthorization
  case unknownAuthorization
}

extension CameraError: LocalizedError {
  var errorDescription: String? {
    switch self {
    case .cameraUnavailable:
      return "Camera unavailable"
    case .cannotAddInput:
      return "Cannot add capture input to session"
    case .cannotAddOutput:
      return "Cannot add video output to session"
    case .createCaptureInput(let error):
      return "Creating capture input for camera: \(error.localizedDescription)"
    case .deniedAuthorization:
      return "Camera access denied"
    case .restrictedAuthorization:
      return "Attempting to access a restricted capture device"
    case .unknownAuthorization:
      return "Unknown authorization status for capture device"
    }
  }
}
