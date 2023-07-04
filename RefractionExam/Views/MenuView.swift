//
//  MenuView.swift
//  RefractionExam
//
//  Created by Hameed Dahabry on 03/07/2023.
//

import SwiftUI

struct MenuView: View {
    @State private var isPresentingExamView = false
    
    var body: some View {
        ZStack {
            VStack(spacing: 24) {
                Text("Refraction exam")
                    .font(.title2)
                    .bold()
                    .foregroundColor(Color("TitleColor"))
                    .padding(.top, 8)
                HStack {
                    Spacer()
                    Image("exam_logo")
                    Spacer()
                }
                
                Text("interactive setup guide for our cool refraction exam")
                    .multilineTextAlignment(.center)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                Button(action: {
                    isPresentingExamView.toggle()
                }, label: {
                    Text("Start Exam")
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
            }
            .background {
                Color(UIColor.systemBackground)
                    .cornerRadius(5)
                    .shadow(color: Color("ShadowColor"), radius: 3)
                
            }
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 32)
        }
        .fullScreenCover(isPresented: $isPresentingExamView) {
            RefractionExamView()
        }
    }
}

struct MenuView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
    }
}
