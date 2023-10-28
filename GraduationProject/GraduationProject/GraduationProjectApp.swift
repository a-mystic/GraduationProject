//
//  GraduationProjectApp.swift
//  GraduationProject
//
//  Created by a mystic on 10/11/23.
//

import SwiftUI

@main
struct GraduationProjectApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                Home()
                    .tabItem { Label("홈", systemImage: "house") }
                Text("추가기능 부분 입니다.\n기록한 사용자의 감정을 차트와 캘린더로 보여주거나 ChatGPT를 이용해서 간단한 상담으로 심리적 안정감을 준다거나...(개발중)")
                    .tabItem { Label("More", systemImage: "ellipsis") }
                Text("설정뷰입니다.\n로그아웃을 하거나 개인정보처리방침을 보여주거나 사용자의 기록된 감정들을 초기화하거나 등의 기능을 생각중입니다...(개발중)")
                    .tabItem { Label("설정", systemImage: "gear") }
            }
        }
    }
}
