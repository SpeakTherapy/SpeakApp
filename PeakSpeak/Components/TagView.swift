//
//  TagView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/24/24.
//

import SwiftUI

struct TagView: View {
    let tag: ExerciseTags
    var isSelected: Bool
    var isSelectable: Bool = false
    var onSelect: (() -> Void)? = nil

    var body: some View {
        Text(tag.rawValue.capitalized)
            .font(.caption)
            .padding(6)
            .background(isSelected ? tagColor(tag: tag) : Color.gray)
            .foregroundColor(.white)
            .cornerRadius(8)
            .onTapGesture {
                if isSelectable {
                    onSelect?()
                }
            }
    }

    func tagColor(tag: ExerciseTags) -> Color {
        switch tag {
        case .articulation:
            return .red
        case .stuttering:
            return .blue
        case .comprehension:
            return .green
        case .audio:
            return .orange
        case .vocal:
            return .purple
        }
    }
}

//#Preview {
//    TagView()
//}
