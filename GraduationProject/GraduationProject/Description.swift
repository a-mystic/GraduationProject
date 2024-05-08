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
                Section("앱") {
                    Text("Snooze는 사용자의 감정케어에 도움을 주기위한 앱 입니다.")
                }
                Section("사용법") {
                    Text("1. 하루일지에 오늘 하루동안 있었던 일들을 기록하고 감정을 케어해주는 콘텐츠를 추천받아요")
                    Text("2. 감정분석 탭에서 자신이 과거에 입력했던 감정들을 확인해요")
                    Text("3. 힘든일이 있다면 AI심리상담 서비스를 이용해요")
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
