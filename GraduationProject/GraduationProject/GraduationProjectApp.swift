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
                    .tabItem { Label("하루일지", systemImage: "square.and.pencil") }
                Text("추가기능 부분 입니다.\n기록한 사용자의 감정을 차트와 캘린더로 보여주거나 기록된 현재부터 일정기간전 동안의 사용자 감정을 선형회귀로 분석해서 오늘의 감정을 추론하고 그에 맞는 주변장소 추천을 생각중 입니다...")
                    .tabItem { Label("감정 기록일지", systemImage: "chart.bar.xaxis.ascending") }
                Text("ChatGPT를 이용해서 간단한 상담으로 심리적 안정감을 주는 탭을 생각중 입니다.....")
                    .tabItem { Label("심리상담", systemImage: "ellipsis.message") }
                Text("설정뷰입니다.\n로그아웃을 하거나 개인정보처리방침을 보여주거나 사용자의 기록된 감정들을 초기화하거나 등의 기능을 생각중입니다...(개발중)")
                    .tabItem { Label("설정", systemImage: "gear") }
            }
        }
    }
}
