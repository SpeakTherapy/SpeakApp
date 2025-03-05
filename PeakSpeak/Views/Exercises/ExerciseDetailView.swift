//
//  ExerciseDetailView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/27/24.
//

import SwiftUI

struct ExerciseDetailView: View {
    let exercise: Exercise

    @State private var currentPage = 1
    @State private var totalPages = 0

    var body: some View {
        ZStack {
            // This will fill the entire screen with your chosen background color
            Color.darkest
                .ignoresSafeArea()

            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text(exercise.description)
                        .font(.body)
                        .padding(.horizontal)

                    HStack {
                        ForEach(exercise.tags, id: \.self) { tag in
                            TagView(tag: tag, isSelected: true, isSelectable: false)
                        }
                    }
                    .padding(.horizontal)

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
                }
            }
        }
        .navigationTitle(exercise.name)
        .navigationBarTitleDisplayMode(.inline)
    }
}




//#Preview {
//    ExerciseDetailView()
//}
