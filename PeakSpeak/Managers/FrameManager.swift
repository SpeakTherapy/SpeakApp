//
//  FrameManager.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/30/24.
//

import AVFoundation
import CoreImage

class FrameManager: NSObject, ObservableObject {
    @Published var frame: CGImage?
    private var videoPermissionGranted = false
    private var audioPermissionGranted = false
    private let captureSession = AVCaptureSession()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    private let context = CIContext()

    override init() {
        super.init()
        checkPermissions()
        sessionQueue.async { [unowned self] in
            self.setUpCaptureSession()
            self.captureSession.startRunning()
        }
    }

    private func checkPermissions() {
        let videoStatus = AVCaptureDevice.authorizationStatus(for: .video)
        let audioStatus = AVCaptureDevice.authorizationStatus(for: .audio)
        
        if videoStatus == .notDetermined {
            requestVideoPermission()
        } else {
            videoPermissionGranted = (videoStatus == .authorized)
        }
        
        if audioStatus == .notDetermined {
            requestAudioPermission()
        } else {
            audioPermissionGranted = (audioStatus == .authorized)
        }
    }

    private func requestVideoPermission() {
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] granted in
            self.videoPermissionGranted = granted
            if granted {
                self.sessionQueue.async {
                    self.setUpCaptureSession()
                }
            }
        }
    }

    private func requestAudioPermission() {
        AVCaptureDevice.requestAccess(for: .audio) { [unowned self] granted in
            self.audioPermissionGranted = granted
        }
    }

    private func setUpCaptureSession() {
        guard videoPermissionGranted, audioPermissionGranted else { return }
        
        do {
            let videoOutput = AVCaptureVideoDataOutput()
            
            guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else {
                throw CameraError.cameraUnavailable
            }
            let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
            guard captureSession.canAddInput(videoDeviceInput) else {
                throw CameraError.cannotAddInput
            }
            captureSession.addInput(videoDeviceInput)
            
            videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "sampleBufferQueue"))
            guard captureSession.canAddOutput(videoOutput) else {
                throw CameraError.cannotAddOutput
            }
            captureSession.addOutput(videoOutput)
            
            if let connection = videoOutput.connection(with: .video) {
                connection.videoOrientation = .portrait
            }
        } catch {
            print("Error setting up capture session: \(error.localizedDescription)")
        }
    }
}

extension FrameManager: AVCaptureVideoDataOutputSampleBufferDelegate {
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        guard let cgImage = imageFromSampleBuffer(sampleBuffer: sampleBuffer) else { return }
        
        DispatchQueue.main.async { [unowned self] in
            self.frame = cgImage
        }
    }
    
    private func imageFromSampleBuffer(sampleBuffer: CMSampleBuffer) -> CGImage? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvPixelBuffer: imageBuffer)
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }
        
        return cgImage
    }
}
