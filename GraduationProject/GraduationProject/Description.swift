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
                    Text("Snooze는 수면에 도움이 필요한 분들을 위한 앱 입니다.")
                }
                Section("사용법") {
                    Text("1. 로그인을 해요.")
                    Text("2. 추가적인 정보들을 입력해요.")
                    Text("3. 오늘 하루동안 있었던 일들을 기록하고 수면에 도움이 되는 콘텐츠를 추천받아요.")
                    Text("4. 추천받은 콘텐츠로 편안한 숙면을 취해요.")
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
