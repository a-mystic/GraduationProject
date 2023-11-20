//
//  ContentRecommender.swift
//  GraduationProject
//
//  Created by a mystic on 10/27/23.
//

import SwiftUI

struct ContentRecommender: View {
    let recommendedContent: String
    let sentimentValue: Double
    
    private var analyzedSentiment: String {
        if sentimentValue <= 1 && sentimentValue > 0.5 {
            return "😄"
        } else if sentimentValue <= 0.5 && sentimentValue > 0 {
            return "😀"
        } else if sentimentValue == 0 {
            return "😐"
        } else if sentimentValue >= -0.5 && sentimentValue < 0 {
            return "🙁"
        } else if sentimentValue >= -1 && sentimentValue < -0.5 {
            return "☹️"
        }
        return "😐"
    }
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                VStack(spacing: 20) {
                    LottieView(jsonName: "bear", loopMode: .repeat(3))
                        .frame(width: 170, height: 170)
                    finalEmotion
//                        SheepAnimation(width: geometry.size.width, height: geometry.size.height/2.3)
                    recommendCard
                        .frame(width: geometry.size.width, height: geometry.size.height * 0.45)
                }
            }
            LottieView(jsonName: "congratulations", loopMode: .playOnce)
        }
    }
    
    private var finalEmotion: some View {
        VStack {
            HStack {
                Text("최종적으로 분석된 감정: ")
                    .bold()
                Text(analyzedSentiment)
                    .font(.largeTitle)
            }
            .font(.title)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.blue.opacity(0.4))
        }
        .bold()
        .font(.footnote)
        .foregroundStyle(.black)
    }
    
    private var recommendCard: some View {
        ZStack(alignment: .bottom) {
            Image("recommenderBackground")
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 14))
            Text("\(recommendedContent) 추천드려요")
                .bold()
                .font(.title)
                .foregroundStyle(.white.opacity(0.9))
                .padding()
                .padding(.horizontal)
                .background(.black.opacity(0.7))
                .clipShape(RoundedRectangle(cornerRadius: 14))
        }
    }
}

#Preview {
    ContentRecommender(recommendedContent: "영화보기", sentimentValue: 0.7)
}
