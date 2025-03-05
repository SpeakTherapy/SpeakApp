//
//  PatientExerciseDetailView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/30/24.
//

import SwiftUI
import AVKit

struct PatientExerciseDetailView: View {
    let exercise: Exercise
    let patientExercise: PatientExercise
    let showStart: Bool
    
    @State private var currentPage = 1
    @State private var totalPages = 0
    
    @StateObject private var viewModel = ExerciseViewModel()
    
    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .short  // Use .medium, .long, or .full for different styles
        formatter.timeStyle = .none   // Hide the time
        return formatter.string(from: date)
    }
    
    var body: some View {
        VStack {
            Text(exercise.description)
                .font(.body)
                .padding()
            
            HStack {
                ForEach(exercise.tags, id: \.self) { tag in
                    TagView(tag: tag, isSelected: true, isSelectable: false)
                }
            }
            
            Text("Assigned on: \(formattedDate(patientExercise.createdAt))")
            Text("Status: \(patientExercise.status)")
            
            if patientExercise.status == .completed {
                if let videoPlayer = viewModel.videoPlayer {
                    VideoPlayer(player: videoPlayer)
                        .cornerRadius(12)
                        .onAppear {
                            videoPlayer.play()
                        }
                } else if viewModel.isLoading {
                    ProgressView("Loading video...")
                } else if let errorMessage = viewModel.downloadError {
                    Text("Error: \(errorMessage)")
                        .foregroundColor(.red)
                }
            }

            Spacer()
            
            // Show PDF navigator if a pdfURL is available
            if let pdfURLString = exercise.pdfURL,
               !pdfURLString.isEmpty,
               let pdfURL = URL(string: pdfURLString) {
                Text("PDF Document")
                    .font(.headline)
                    .padding(.horizontal)
                
                PDFNavigatorView(url: pdfURL, currentPage: $currentPage, totalPages: $totalPages)
                    .frame(height: 400)
                    .padding(.horizontal)
                
                HStack {
                    Button("Previous") {
                        if currentPage > 1 {
                            currentPage -= 1
                        }
                    }
                    .disabled(currentPage <= 1)
                    
                    Spacer()
                    
                    Text("Page \(currentPage) of \(totalPages)")
                    
                    Spacer()
                    
                    Button("Next") {
                        if currentPage < totalPages {
                            currentPage += 1
                        }
                    }
                    .disabled(currentPage >= totalPages)
                }
                .padding(.horizontal)
            }
            
            Spacer()
            
            if showStart {
                NavigationLink(destination: ExerciseRecordingView(patientExercise: patientExercise)) {
                    Text("Start")
                        .font(.title3)
                        .padding(.vertical, 5)
                        .padding(.horizontal)
                        .background(Color.gray)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
            }
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(.darkest)
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            viewModel.loadVideo(patientExerciseID: patientExercise.id)
        }
    }
}

//#Preview {
//    PatientExerciseDetailView()
//}
