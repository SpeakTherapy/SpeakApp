//
//  ExerciseRecordingView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/30/24.
//

import SwiftUI
import AVFoundation
import AVKit

struct ExerciseRecordingView: View {
    let patientExercise: PatientExercise
    @StateObject private var cameraModel = CameraManager()
    @StateObject private var viewModel = ExerciseViewModel()
    @State private var isRecording = false
    @State private var recordedVideoURL: URL? = nil
    @State private var showingVideoPlayer = false
    @State private var showSuccessAlert = false
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            if let url = recordedVideoURL, showingVideoPlayer {
                VideoPlayer(player: AVPlayer(url: url))
                    .cornerRadius(12)
                HStack {
                    Button(action: {
                        recordedVideoURL = nil
                        showingVideoPlayer = false
                        cameraModel.configure()
                    }) {
                        Text("Discard")
                            .padding()
                            .background(Color.red)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                    Button(action: {
                        viewModel.uploadRecording(patientExerciseID: patientExercise.patientExerciseId, videoURL: recordedVideoURL!) {
                            showSuccessAlert = true
                        }
                    }) {
                        Text("Submit")
                            .padding()
                            .background(Color.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding()
            } else {
                if cameraModel.isConfigured {
                    CameraView(camera: cameraModel)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white, lineWidth: 2)
                        )
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    HStack {
                        if isRecording {
                            Button(action: {
                                stopRecording()
                            }) {
                                Text("Stop Recording")
                                    .padding()
                                    .background(Color.red)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        } else {
                            Button(action: {
                                startRecording()
                            }) {
                                Text("Start Recording")
                                    .padding()
                                    .background(Color.green)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                            }
                        }
                    }
                } else {
                    Text("Camera Not Available")
                }
            }
        }
        .background(.darkest)
        .onAppear {
            cameraModel.configure()
        }
        .onChange(of: viewModel.uploadError) { new in
            if new == nil {
                presentationMode.wrappedValue.dismiss()
            } else {
                // Handle the error, maybe show an alert
                print("Upload error: \(new ?? "")")
            }
        }
        .alert(isPresented: $showSuccessAlert) {
            Alert(
                title: Text("Upload Successful"),
                message: Text("Your recording has been uploaded successfully."),
                dismissButton: .default(Text("OK")) {
                    presentationMode.wrappedValue.dismiss()
                }
            )
        }
    }

    private func startRecording() {
        cameraModel.startRecording { url in
            recordedVideoURL = url
            showingVideoPlayer = true
        }
        isRecording = true
    }

    private func stopRecording() {
        cameraModel.stopRecording()
        isRecording = false
    }
}

//#Preview {
//    ExerciseRecordingView()
//}
