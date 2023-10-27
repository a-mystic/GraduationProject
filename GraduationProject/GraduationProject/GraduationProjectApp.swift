//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by a mystic on 10/11/23.
//

import SwiftUI

@main
struct GraduationProjectApp: App {
    @State private var currentTab = 2
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $currentTab) {
                ContentView()
                    .tabItem { Label("홈", systemImage: "house") }
                Text("추가기능 부분 입니다.(개발중)")
                    .tabItem { Label("More", systemImage: "ellipsis") }
                Text("설정뷰입니다.(개발중)")
                    .tabItem { Label("설정", systemImage: "gear") }
            }
        }
    }
}
