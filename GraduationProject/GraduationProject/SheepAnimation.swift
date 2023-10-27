//
//  SheepAnimation.swift
//  GraduationProject
//
//  Created by a mystic on 10/27/23.
//

import SwiftUI

struct SheepAnimation: View {
    var width: CGFloat
    var height: CGFloat
    
    private let moveInterval: Double = 3
    private var bounceInterval: Double {
        moveInterval / 3
    }
    
    @State private var bouncing = false
    @State private var startPosition: CGFloat = -100
    
    var body: some View {
        ZStack {
            background
            GeometryReader { geometry in
                Text("🐑")
                    .position(x: startPosition, y: geometry.size.height / 2)
                    .offset(y: !bouncing ? -geometry.size.height * 0.9 : geometry.size.height / 2.5)
                    .animation(.linear(duration: 1), value: bouncing)
                    .font(.system(size: geometry.size.width * 0.15))
                    .onAppear {
                        wave()
                    }
            }
            .frame(height: height)
            .padding(.horizontal)
        }
    }
    
    private var background: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14).foregroundStyle(.black.opacity(0.5))
                .frame(width: width, height: height)
            Text("🌕")
                .scaleEffect(2)
                .frame(width: width, height: height)
                .offset(x: -width / 3, y: -height / 3)
            Text("☁️")
                .scaleEffect(3)
                .frame(width: width, height: height)
                .offset(x: -width * 0.1, y: -height / 4)
            Text("☁️")
                .scaleEffect(3)
                .frame(width: width, height: height)
                .offset(x: width * 0.2, y: -height / 4)
        }
    }

    @State private var timer: Timer?

    private func wave() {
        timer = Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            bounce()
        }
    }
    
    private func bounce() {
        startPosition = -100
        withAnimation(.linear(duration: bounceInterval)) {
            bouncing.toggle()
        }
        withAnimation(.linear(duration: moveInterval)) {
            startPosition = 600
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + bounceInterval + 0.14) {
            bouncing.toggle()
        }
    }
}
