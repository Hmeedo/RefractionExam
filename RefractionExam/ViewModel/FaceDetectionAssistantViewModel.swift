//
//  FaceDetectionAssistantViewModel.swift
//  RefractionExam
//
//  Created by Hameed Dahabry on 03/07/2023.
//

import SwiftUI

class FaceDetectionAssistantViewModel: ObservableObject {
    @Published var instructionTitle : String = "2. Position your face in front of the camera."
    @Published var instructionHint : String = "Your face not detected yet."
    @Published var stepCompleted : Bool = false
    @Published var stepReadyToComplete : Bool = false {
        didSet {
            if stepReadyToComplete {
                instructionHint = "Face detected!, you can start the Exam."
            }else {
                instructionHint = "Your face not detected yet."
            }
        }
    }
}
