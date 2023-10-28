//
//  MoreInfoView.swift
//  GraduationProject
//
//  Created by a mystic on 10/28/23.
//

import SwiftUI

struct MoreInfoView: View {
    @Binding var loginIsNeeded: Bool
    
    private let genders = ["남성", "여성"]
    private let ages = ["어린이", "청소년", "청년", "중년", "노년"]
    private let badThings = ["없음", "교통카드 결제", "키오스크 사용", "추가예정.."]
    
    @State private var selectedGender = ""
    @State private var selectedAge = ""
    @State private var selectedBadThing = "없음"
    
    var body: some View {
        NavigationStack {
            Form {
                Section("성별을 선택해 주세요.") {
                    HStack {
                        Text("성별")
                        Picker("Choose gender", selection: $selectedGender) {
                            ForEach(genders, id: \.self) { gender in
                                Text(gender)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                }
                Section("연령대를 선택해 주세요.") {
                    HStack {
                        Text("연령대")
                        Picker("Choose age", selection: $selectedAge) {
                            ForEach(ages, id: \.self) { age in
                                Text(age)
                            }
                        }
                        .pickerStyle(WheelPickerStyle())
                    }
                }
                Section("최근 겪은 불편한 사항이 있으시면 선택해주세요.") {
                    Picker("불편사항", selection: $selectedBadThing) {
                        ForEach(badThings, id: \.self) { badThing in
                            Text(badThing)
                        }
                    }
                    .pickerStyle(MenuPickerStyle())
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    save
                }
            }
        }
    }
    
    private var save: some View {
        Button("Save") {
            loginIsNeeded = false
        }
    }
}

#Preview {
    MoreInfoView(loginIsNeeded: .constant(true))
}
