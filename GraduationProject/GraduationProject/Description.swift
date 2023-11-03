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
                    Text("1. 로그인을 해요.")
                    Text("2. 추가적인 정보들을 입력해요.")
                    Text("3. 오늘 하루동안 있었던 일들을 기록하고 오늘 하루동안의 감정을 케어해주는 콘텐츠를 추천받아요.")
                    Text("4. 추천받은 콘텐츠로 감정이 안좋았다면 좋은 감정을, 좋았다면 좋은 감정을 더 오래 느끼게 됩니다.")
                    Text("5. 자신의 과거의 감정들을 확인해요.")
                    Text("6. 힘든일이 있다면 간단한 AI심리상담 서비스를 이용해요.")
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
