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
                        Text("애니메이션 감상하는것을 추천드려요.")
                            .bold()
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
