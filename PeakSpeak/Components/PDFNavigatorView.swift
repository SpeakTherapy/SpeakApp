//
//  PDFKitView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 2/20/25.
//

import SwiftUI
import PDFKit

struct PDFNavigatorView: UIViewRepresentable {
    let url: URL
    @Binding var currentPage: Int
    @Binding var totalPages: Int

    class Coordinator: NSObject {
        var parent: PDFNavigatorView
        var document: PDFDocument?

        init(parent: PDFNavigatorView) {
            self.parent = parent
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> PDFView {
        let pdfView = PDFView()
        pdfView.autoScales = true
        pdfView.displayMode = .singlePage
        pdfView.displayDirection = .vertical
        pdfView.isUserInteractionEnabled = false // disable user scrolling
        if let document = PDFDocument(url: url) {
            context.coordinator.document = document
            pdfView.document = document
            DispatchQueue.main.async {
                self.totalPages = document.pageCount
            }
            if let page = document.page(at: currentPage - 1) {
                pdfView.go(to: page)
            }
        }
        return pdfView
    }

    func updateUIView(_ uiView: PDFView, context: Context) {
        guard let document = context.coordinator.document else { return }
        if totalPages != document.pageCount {
            DispatchQueue.main.async {
                self.totalPages = document.pageCount
            }
        }
        if let page = document.page(at: currentPage - 1) {
            uiView.go(to: page)
        }
    }
}


//#Preview {
//    PDFNavigatorView()
//}
