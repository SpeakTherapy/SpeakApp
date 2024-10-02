//
//  CameraView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/30/24.
//

import SwiftUI
import AVFoundation

struct CameraView: UIViewRepresentable {
    class Coordinator: NSObject {
        var parent: CameraView
        var previewLayer: AVCaptureVideoPreviewLayer?

        init(parent: CameraView) {
            self.parent = parent
        }

        func setupPreviewLayer(for view: UIView, captureSession: AVCaptureSession) {
            let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
            previewLayer.videoGravity = .resizeAspectFill
            previewLayer.connection?.automaticallyAdjustsVideoMirroring = false
            previewLayer.connection?.isVideoMirrored = true
            previewLayer.cornerRadius = 12
            previewLayer.masksToBounds = true
            previewLayer.frame = view.bounds
            view.layer.addSublayer(previewLayer)
            self.previewLayer = previewLayer
        }
        
    }

    var camera: CameraManager

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: UIScreen.main.bounds)
        view.backgroundColor = .darkest
        if let captureSession = camera.captureSession {
            context.coordinator.setupPreviewLayer(for: view, captureSession: captureSession)
        }
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
    }
}


//#Preview {
//    CameraView()
//}
