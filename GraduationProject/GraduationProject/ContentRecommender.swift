//
//  ContentRecommender.swift
//  GraduationProject
//
//  Created by a mystic on 10/27/23.
//

import SwiftUI

struct ContentRecommender: View {
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                LottieView(jsonName: "congratulations", loopMode: .playOnce)
                ScrollView {
                    VStack(spacing: 20) {
                        LottieView(jsonName: "bear", loopMode: .repeat(3))
                            .frame(width: 200, height: 200)
                        VStack {
                            HStack {
                                Text("분석한 감정: ")
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
                        SheepAnimation(width: geometry.size.width, height: geometry.size.height/2)
                    }
                }
            }
        }
    }
}

#Preview {
    ContentRecommender()
}
