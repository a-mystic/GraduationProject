//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by a mystic on 10/11/23.
//

import SwiftUI

@main
struct GraduationProjectApp: App {
    @StateObject private var contentsManager = ContentsManager()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                HaruDiary()
                    .tabItem { 
                        Label("하루일지", systemImage: "square.and.pencil")
                    }
                EmotionRecord()
                    .tabItem {
                        Label("감정기록일지", systemImage: "chart.bar.xaxis.ascending")
                    }
                ChatBot()
                    .tabItem { 
                        Label("심리상담", systemImage: "ellipsis.message")
                    }
            }
            .environmentObject(ContentsManager())
        }
    }
}
