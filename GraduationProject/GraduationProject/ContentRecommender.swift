//
//  ContentRecommender.swift
//  GraduationProject
//
//  Created by a mystic on 10/27/23.
//

import SwiftUI

struct ContentRecommender: View {
    let sentiment: String
    let confidence: String
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LottieView(jsonName: "congratulations", loopMode: .playOnce)
                ScrollView {
                    VStack(spacing: 20) {
                        LottieView(jsonName: "bear", loopMode: .repeat(3))
                            .frame(width: 170, height: 170)
                        VStack {
                            HStack {
                                Text("분석한 감정: \(sentiment)")
                                    .bold()
                                Text("😀")
                                    .font(.largeTitle)
                            }
                            .font(.title)
                            Text("애니메이션 감상하는것을 추천드려요.")
                                .bold()
                        }
                        .padding()
                        .background {
                            RoundedRectangle(cornerRadius: 14)
                                .foregroundStyle(.blue.opacity(0.4))
                        }
                        HStack {
                            Text("분석한 감정 수치: ")
                            Text("\(confidence)")
                        }
                        .bold()
                        .font(.footnote)
                        .foregroundStyle(.gray)
                        SheepAnimation(width: geometry.size.width, height: geometry.size.height/2.3)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentRecommender(sentiment: "positive", confidence: "positive = 0.5, negative = 0.3, neutral = 0.2")
}
