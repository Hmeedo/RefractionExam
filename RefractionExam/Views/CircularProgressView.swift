//
//  CircularProgressView.swift
//  RefractionExam
//
//  Created by Hameed Dahabry on 03/07/2023.
//

import SwiftUI

struct CircularProgressView: View {
    let progress: Double
    let color : Color
    
    var body: some View {
        ZStack {
            Circle()
                .trim(from: 0, to: progress)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 16,
                        lineCap: .round
                    )
                )
                .rotationEffect(.degrees(-90))
                .animation(.easeOut, value: progress)
            
        }
    }
}
