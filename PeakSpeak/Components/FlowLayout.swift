//
//  FlowLayout.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/24/24.
//

import SwiftUI

struct FlowLayout<Content: View>: View {
    let items: [ExerciseTags]
    @Binding var selectedTags: [ExerciseTags]
    let content: (ExerciseTags, Bool) -> Content

    init(items: [ExerciseTags], selectedTags: Binding<[ExerciseTags]>, @ViewBuilder content: @escaping (ExerciseTags, Bool) -> Content) {
        self.items = items
        self._selectedTags = selectedTags
        self.content = content
    }

    var body: some View {
        GeometryReader { geometry in
            self.generateContent(in: geometry)
        }
    }

    private func generateContent(in g: GeometryProxy) -> some View {
        var width = CGFloat.zero
        var height = CGFloat.zero

        return ZStack(alignment: .topLeading) {
            ForEach(items, id: \.self) { item in
                self.content(item, selectedTags.contains(item))
                    .padding([.horizontal, .vertical], 4)
                    .alignmentGuide(.leading, computeValue: { d in
                        if (abs(width - d.width) > g.size.width) {
                            width = 0
                            height -= d.height
                        }
                        let result = width
                        if item == self.items.last {
                            width = 0 // last item
                        } else {
                            width -= d.width
                        }
                        return result
                    })
                    .alignmentGuide(.top, computeValue: { d in
                        let result = height
                        if item == self.items.last {
                            height = 0 // last item
                        }
                        return result
                    })
            }
        }
    }
}


//#Preview {
//    FlowLayout()
//}
