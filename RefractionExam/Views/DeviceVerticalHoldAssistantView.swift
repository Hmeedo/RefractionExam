//
//  DeviceVerticalHoldAssistantView.swift
//  RefractionExam
//
//  Created by Hameed Dahabry on 03/07/2023.
//

import SwiftUI
import SceneKit

struct DeviceVerticalHoldAssistantView: View {
    @StateObject var viewModel : DeviceVerticalHoldAssistantViewModel
    
    @State private var povName = "camera"
    @State private var iphoneScene : SCNScene = {
        let scene =  SCNScene(named: "iphone.scn")!
        scene.background.contents = UIColor.systemBackground
        return scene
    }()
    
    var body: some View {
        VStack(spacing: 24) {
            Text(viewModel.instructionTitle)
                .font(.headline)
                .bold()
                .foregroundColor(Color("TitleColor"))
            
            ZStack {
                CircularProgressView(progress: viewModel.correctAngleStepProgress,
                                     color: viewModel.stepReadyToComplete ? .green : .accentColor)
                .frame(width: 250, height: 250)
                SceneView (
                    scene: iphoneScene,
                    pointOfView: iphoneScene.rootNode.childNode(withName: povName, recursively: true),
                    options: [
                        .autoenablesDefaultLighting,
                        .temporalAntialiasingEnabled
                    ]
                )
                .frame(width: 100, height: 200)
                .background(.clear)
            }
            
            Text(viewModel.instructionHint)
                .font(.caption)
                .multilineTextAlignment(.center)
            
            Button(action: {
                viewModel.stepCompleted.toggle()
            }, label: {
                Text("Next Step")
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
        .padding(.horizontal, 16)
        .onAppear {
            viewModel.listenToDeviceMotionUpdates()
        }
        .onChange(of: viewModel.devicePitch, perform: { newValue in
            iphoneNode?.rotation.w = Float(newValue)
        })
    }
    
    var iphoneNode : SCNNode? {
        return iphoneScene.rootNode.childNode(withName: "Sketchfab_model", recursively: true)
    }
}
