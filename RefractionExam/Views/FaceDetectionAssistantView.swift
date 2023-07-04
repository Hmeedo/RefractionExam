//
//  FaceDetectionAssistantView.swift
//  RefractionExam
//
//  Created by Hameed Dahabry on 03/07/2023.
//

import SwiftUI

struct FaceDetectionAssistantView : View {
    @StateObject var viewModel : FaceDetectionAssistantViewModel
    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.instructionTitle)
                .font(.headline)
                .bold()
                .foregroundColor(Color("TitleColor"))
            
            CameraView(faceDetected: $viewModel.stepReadyToComplete)
                .frame(height: 200)
                .cornerRadius(8)
            
            Text(viewModel.instructionHint)
                .font(.caption)
                .multilineTextAlignment(.center)
            
            Button(action: {
                viewModel.stepCompleted.toggle()
            }, label: {
                Text("Start Test")
                    .font(.subheadline)
                    .padding(.vertical, 8)
                    .padding(.horizontal, 16)
                    .foregroundColor(.white)
            })
            .background {
                Color.accentColor
                    .cornerRadius(.infinity)
            }
            .padding(.bottom, 8)
            .disabled(viewModel.stepReadyToComplete == false)
        }
        .padding(.horizontal,16)
    }
}
