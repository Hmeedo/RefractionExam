//
//  ContentView.swift
//  RefractionExam
//
//  Created by Hameed Dahabry on 02/07/2023.
//
import SwiftUI

struct RefractionExamView: View {
    @StateObject var deviceHoldAssistantViewModel = DeviceVerticalHoldAssistantViewModel()
    @StateObject var faceDetectionViewModel = FaceDetectionAssistantViewModel()
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("Refraction Exam")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("TitleColor"))
                if deviceHoldAssistantViewModel.stepCompleted == true, faceDetectionViewModel.stepCompleted == true {
                    
                    Text("Setup complete!")
                        .font(.headline)
                        .bold()
                        .foregroundColor(Color("TitleColor"))
                
                    Button(action: {
                        dismiss()
                    }, label: {
                        Text("Back to Menu")
                            .font(.subheadline)
                            .padding(.vertical, 8)
                            .padding(.horizontal, 16)
                            .foregroundColor(.white)
                    })
                    .background {
                        Color.accentColor
                            .cornerRadius(.infinity)
                    }
                    
                }else if deviceHoldAssistantViewModel.stepCompleted == true {
                    FaceDetectionAssistantView(viewModel: faceDetectionViewModel)
                }else {
                    DeviceVerticalHoldAssistantView(viewModel: deviceHoldAssistantViewModel)
                }
                
            }.onChange(of: faceDetectionViewModel.stepCompleted) { newValue in
                if deviceHoldAssistantViewModel.stepCompleted == true, faceDetectionViewModel.stepCompleted == true {
                    // all steps completed we should stop listen to device motition
                    deviceHoldAssistantViewModel.stopListeningToDeviceMotionUpdates()
                }
            }
            .toolbar {
                // show cancel button only if test is not completed yet
                if deviceHoldAssistantViewModel.stepCompleted == false || faceDetectionViewModel.stepCompleted == false {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button("Cancel") {
                            deviceHoldAssistantViewModel.stopListeningToDeviceMotionUpdates()
                            dismiss()
                        }
                        .bold()
                    }
                }
            }
        }
    }
}

struct RefractionExamView_Previews: PreviewProvider {
    static var previews: some View {
        RefractionExamView()
    }
}

