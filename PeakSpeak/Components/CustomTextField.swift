//
//  CustomTextField.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/21/24.
//

import SwiftUI

struct CustomTextField: UIViewRepresentable {
    class Coordinator: NSObject, UITextFieldDelegate {
        var parent: CustomTextField

        init(parent: CustomTextField) {
            self.parent = parent
        }

        @objc func textFieldDidChange(_ textField: UITextField) {
            parent.text = textField.text ?? ""
        }
    }

    @Binding var text: String
    var placeholder: String
    var isSecure: Bool
    var isActive: Bool // Add isActive parameter

    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }

    func makeUIView(context: Context) -> UITextField {
        let textField = UITextField(frame: .zero)
        textField.placeholder = placeholder
        textField.text = text
        textField.isSecureTextEntry = isSecure
        textField.textContentType = .oneTimeCode
        textField.delegate = context.coordinator
        textField.autocapitalizationType = .none
        textField.addTarget(context.coordinator, action: #selector(Coordinator.textFieldDidChange), for: .editingChanged)
        return textField
    }

    func updateUIView(_ uiView: UITextField, context: Context) {
        uiView.text = text
        uiView.textColor = isActive ? UIColor(.darkest) : UIColor(.light)
        uiView.font = .systemFont(ofSize: 14)
        uiView.isSecureTextEntry = isSecure
        uiView.attributedPlaceholder = NSAttributedString(
            string: placeholder,
            attributes: [NSAttributedString.Key.foregroundColor: isActive ? UIColor(.darkest) : UIColor(.light)]
        )
        uiView.tintColor = UIColor(.darkBack) // Set cursor color based on isActive
    }
}


struct CustomTextFieldModifier: ViewModifier {
    var isActive: Bool
    
    func body(content: Content) -> some View {
        content
            .padding()
            .background(isActive ? .bright : .darkest)
            .cornerRadius(8)
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isActive ? Color.bright : Color.light, lineWidth: 2)
            )
            .padding(.horizontal)
    }
}

//#Preview {
//    CustomTextField()
//}
