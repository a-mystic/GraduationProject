//
//  DetailRecord.swift
//  GraduationProject
//
//  Created by a mystic on 9/13/24.
//

import SwiftUI

struct DetailRecord: View {
    @Binding var selectedDate: String
    
    @State private var selectedDiary = Diary(date: "", emotionValue: 0, content: "")
    @State private var emotionBarAnimationValue: Double = 0

    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationStack {
            Form {
                Section("작성일") {
                    Text(selectedDiary.date)
                }
                Section("감정") {
                    VStack(spacing: 20) {
                        Text(emotionValueToEmotion(selectedDiary.emotionValue))
                            .font(.system(size: 50))
                        ProgressView(value: emotionBarAnimationValue, total: 1)
                        Text("수치: \(Int(emotionBarAnimationValue * 100))%")
                            .font(.title3)
                    }
                    .padding()
                }
                Section("일지") {
                    Text(selectedDiary.content)
                        .font(.body)
                }
            }
            .onAppear {
                decodeDiary()
                if let findedDiary = recordedDiarys.first(where: { diary in
                    diary.date == selectedDate
                }) {
                    selectedDiary = findedDiary
                }
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                    if emotionBarAnimationValue >= abs(selectedDiary.emotionValue) {
                        timer.invalidate()
                    } else {
                        DispatchQueue.global(qos: .background).async {
                            emotionBarAnimationValue += 0.01
                        }
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private func emotionValueToEmotion(_ value: Double) -> String {
        if value <= 1 && value > 0.5 {
            return "😄"
        } else if value <= 0.5 && value > 0 {
            return "😀"
        } else if value == 0 {
            return "😐"
        } else if value >= -0.5 && value < 0 {
            return "🙁"
        } else if value >= -1 && value < -0.5 {
            return "☹️"
        }
        return "😐"
    }
    
    @State private var recordedDiarys: [Diary] = []
    @AppStorage("recordedDiarys") var recordedDiarysAppStorage = Data()
    
    private func decodeDiary() {
        if let data = try? JSONDecoder().decode([Diary].self, from: recordedDiarysAppStorage) {
            recordedDiarys = data
        }
    }
}

#Preview {
    DetailRecord(selectedDate: .constant("2024-09-03"))
}
