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
    private let ages = ["어린이", "청년", "중년", "노년"]
    
    @State private var gender = ""
    @State private var age = ""
    
    var body: some View {
        NavigationStack {
            Form {
                Section("성별을 선택해 주세요") {
                    HStack {
                        Text("성별")
                        Picker("Choose gender", selection: $gender) {
                            
                        }
                    }
                }
                Section("연령대를 선택해 주세요.") {
                    
                }
            }
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
