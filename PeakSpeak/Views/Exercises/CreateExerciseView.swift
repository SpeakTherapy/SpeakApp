//
//  CreateExerciseView.swift
//  PeakSpeak
//
//  Created by Tanish Bhowmick on 7/24/24.
//

import SwiftUI

struct CreateExerciseView: View {
    @StateObject private var viewModel = ExerciseViewModel()
    @State private var name = ""
    @State private var description = ""
    @State private var selectedTags: [ExerciseTags] = []
    @State private var isNameActive: Bool = false
    @State private var isDescriptionActive: Bool = false
    @State private var selectedVisibility: ExerciseFilter = .global
    
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HStack {
                BackButton()
                Spacer()
            }
            Spacer()

            Text("Create Exercise")
                .font(.largeTitle)
                .fontWeight(.bold)
                .padding(.bottom, 30)
            
            CustomTextField(text: $name, placeholder: "Exercise Name", isSecure: false, isActive: isNameActive)
                .modifier(CustomTextFieldModifier(isActive: isNameActive))
                .padding(.vertical, 20)
                .onTapGesture {
                    isNameActive = true
                    isDescriptionActive = false
                }
                .frame(maxHeight: .leastNormalMagnitude)
                .padding(.bottom, 50)

            CustomTextField(text: $description, placeholder: "Exercise Description", isSecure: false, isActive: isDescriptionActive)
                .modifier(CustomTextFieldModifier(isActive: isDescriptionActive))
                .onTapGesture {
                    isNameActive = false
                    isDescriptionActive = true
                }
                .frame(maxHeight: .leastNormalMagnitude)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("Visibility")
                    .font(.headline)
                
                Picker("Visibility", selection: $selectedVisibility) {
                    ForEach(ExerciseFilter.allCases) { visibility in
                        Text(visibility.rawValue).tag(visibility)
                    }
                }
                .pickerStyle(.segmented)
            }
            .padding(.horizontal)
            .padding(.top, 20)

            
            Text("Tags")
                .font(.headline)
                .padding(.top)

            FlowLayout(items: ExerciseTags.allCases, selectedTags: $selectedTags) { tag, isSelected in
                TagView(tag: tag, isSelected: isSelected, isSelectable: true, onSelect: {
                    if isSelected {
                        selectedTags.removeAll { $0 == tag }
                    } else {
                        selectedTags.append(tag)
                    }
                })
            }
            .padding(.horizontal)

            Button(action: {
                let selectedTagStrings = selectedTags.map { $0.rawValue }
                let isGlobal = selectedVisibility == .global
                viewModel.createExercise(name: name, description: description, tags: selectedTagStrings, videoURL: "", isGlobal: isGlobal)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("Create")
                    .padding()
                    .background(name.isEmpty || description.isEmpty || selectedTags.isEmpty ? Color.gray : Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .padding()
            .disabled(selectedTags.isEmpty)

            Spacer()
        }
        .addDismissKeyboardGesture()
        .background(.darkest)
        .navigationBarHidden(true)
        .onChange(of: viewModel.creationSuccess) { new in
            if new {
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

//#Preview {
//    CreateExerciseView().environmentObject(ExerciseViewModel())
//}
