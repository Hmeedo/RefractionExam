//
//  DeviceVerticalHoldAssistantViewModel.swift
//  RefractionExam
//
//  Created by Hameed Dahabry on 03/07/2023.
//

import SwiftUI
import CoreMotion

enum DeviceAngleState {
    case unknown
    case low
    case correct
    case high
}

class DeviceVerticalHoldAssistantViewModel: ObservableObject {
    @Published var deviceAngleState : DeviceAngleState = .unknown
    @Published var instructionHint : String = "Position the phone at the correct angle"
    @Published var instructionTitle : String = "1. Position the phone at the correct angle vertically."
    @Published var devicePitch : Double = 0
    @Published var correctAngleStepProgress : Double = 0
    @Published var stepReadyToComplete : Bool = false
    @Published var stepCompleted : Bool = false
    
    private var timer : Timer?
    private var currentCorrectStateHoldingTime : TimeInterval = 0
    private let maxCorrectStateHoldingTime : TimeInterval = 3
    private let deviceCorrectAngleRange : ClosedRange<Double> = 70...110
    private var deviceAngle : Double {
        // the pitch in radians convert to degree
        devicePitch * 180 / Double.pi
    }

    private let motionManager = CMMotionManager()
    
    func listenToDeviceMotionUpdates() {
        if motionManager.isDeviceMotionAvailable {
            motionManager.deviceMotionUpdateInterval = 0.01
            motionManager.startDeviceMotionUpdates(to: OperationQueue()) { [weak self] (motion, error) -> Void in
                guard let motion = motion else {
                    return
                }
                DispatchQueue.main.async {
                    self?.handleDeviceMotionUpdate(motion)
                }
            }
        }
        else {
            print("Device motion unavailable")
        }
    }
    
    func stopListeningToDeviceMotionUpdates() {
        if motionManager.isDeviceMotionActive {
            motionManager.stopDeviceMotionUpdates()
        }
    }
    
    private func handleDeviceMotionUpdate(_ motion : CMDeviceMotion) {
        calculateDevicePitch(motion: motion)
        updateDeviceAngleState()
    }
    
    private func updateDeviceAngleState() {
        if deviceCorrectAngleRange ~= deviceAngle, deviceAngleState != .correct {
            deviceAngleState = .correct
            instructionHint = "please hold the device in this position for 3 seconds"
            startTimer()
            generateFeedback(.success)
        }else if deviceCorrectAngleRange.lowerBound > deviceAngle, deviceAngleState != .low {
            deviceAngleState = .low
            instructionHint = "You are holding the device too low please rise the phone"
            resetTimer()
            
        }else if deviceCorrectAngleRange.upperBound < deviceAngle, deviceAngleState != .high {
            deviceAngleState = .high
            instructionHint = "You are holding the device too high please lower the phone"
            resetTimer()
        }
    }
    
    private func generateFeedback(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(type)
    }
    
    private func calculateDevicePitch(motion : CMDeviceMotion) {
        // the device give same pitch if the divce is face down or up, using gravity z we can determine when the device is face down and adjust the pitch value
        self.devicePitch = motion.gravity.z > 0 ? (Double.pi - motion.attitude.pitch) : motion.attitude.pitch
    }
    
    private func startTimer() {
        guard timer == nil, correctAngleStepProgress != 1 else { return }
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true, block: { [weak self] timer in
            self?.currentCorrectStateHoldingTime += 0.05
            self?.correctAngleStepProgress = (self?.currentCorrectStateHoldingTime ?? 0) / (self?.maxCorrectStateHoldingTime ?? 1)
            if (self?.correctAngleStepProgress ?? 0) >= 1 {
                self?.stepReadyToComplete = true
                self?.stopTimer()
            }
        })
    }
    
    private func resetTimer() {
        stopTimer()
        correctAngleStepProgress = 0
        stepReadyToComplete = false
        stepCompleted = false
    }
    
    private func stopTimer() {
        timer?.invalidate()
        timer = nil
        currentCorrectStateHoldingTime = 0
    }
}
