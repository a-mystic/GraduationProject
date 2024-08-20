//
//  Description.swift
//  GraduationProject
//
//  Created by a mystic on 10/27/23.
//

import SwiftUI

struct Description: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("앱 소개") {
                    Text("Snooze는 사용자의 감정케어에 도움을 주기위한 앱 이에요")
                }
                Section("사용법") {
                    Text("1. 하루일지 탭에서 오늘 하루동안 있었던 일들을 작성해보고 콘텐츠를 추천받아요")
                    Text("2. 감정기록 탭에서 과거에 입력했던 감정들을 확인하고 진단받아요")
                    Text("3. 힘든일이 있다면 AI심리상담 챗봇을 이용해요")
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    Description()
}
