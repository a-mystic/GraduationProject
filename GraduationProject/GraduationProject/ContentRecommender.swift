//
//  ContentRecommender.swift
//  GraduationProject
//
//  Created by a mystic on 10/27/23.
//

import SwiftUI

struct ContentRecommender: View {
    var body: some View {
        ZStack {
            LottieView(jsonName: "congratulations", loopMode: .playOnce)
            ScrollView {
                VStack {
                    LottieView(jsonName: "bear", loopMode: .repeat(3))
                        .frame(width: 200, height: 200)
                    Text("애니메이션을 보는것을 추천드려요.")
                }
            }
        }
    }
}

#Preview {
    ContentRecommender()
}
