//
//  CreateExerciseView.swift
//  SpeakApp
//
//  Created by Tanish Bhowmick on 5/30/24.
//

import SwiftUI

struct CreateExerciseView: View {
    @StateObject private var exerciseViewModel = ExerciseViewModel()
    @State private var exerciseName = ""
    @State private var exerciseDescription = ""
    @State private var exerciseCategory = ""
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
                .padding(.bottom, 20)
            
            TextField("Exercise Name", text: $exerciseName)
                .autocapitalization(.none)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Exercise Description", text: $exerciseDescription)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            TextField("Exercise Category", text: $exerciseCategory)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()
            
            Button("Create Exercise") {
                // Create exercise
                exerciseViewModel.createExercise(title: exerciseName, description: exerciseDescription, category: exerciseCategory)
            }
            
            Spacer()
            
        }
        .navigationBarHidden(true)
        .onChange(of: exerciseViewModel.creationSuccess) { success in
            if success {
                // Go back to previous screen
                presentationMode.wrappedValue.dismiss()
            }
        }
    }
}

//#Preview {
//    CreateExerciseView()
//}
