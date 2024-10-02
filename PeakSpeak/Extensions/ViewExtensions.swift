//
//  ViewExtensions.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import Foundation
import SwiftUI

struct GlobalBackgroundModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .background(.darkest)
            .edgesIgnoringSafeArea(.all)
    }
}

extension View {
    func applyGlobalBackground() -> some View {
        self.modifier(GlobalBackgroundModifier())
    }

    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
    func addDismissKeyboardGesture() -> some View {
        return self.onTapGesture {
            self.hideKeyboard()
        }
    }
}
