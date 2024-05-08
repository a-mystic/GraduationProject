//
//  EmotionRecord.swift
//  GraduationProject
//
//  Created by a mystic on 4/9/24.
//

import SwiftUI

struct EmotionRecord: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: 0) {
                emotionDiagnosis(in: geometry.size)
                calendar
            }
        }
    }
    
    private var diagnosedEmotion: String {
        var sum: Double = 0
        testEmotionDatas.values.forEach { value in
            sum += value
        }
        return emotionValueToEmotion(sum/Double(testEmotionDatas.count))
    }
    
    private var diagnosisMessage: String {
        var sum: Double = 0
        testEmotionDatas.values.forEach { value in
            sum += value
        }
        let mean = sum/Double(testEmotionDatas.count)
        if mean > 0 {
            return "이번주 느끼신 감정은 행복입니다"
        } else {
            return "이번주 느끼신 감정은 불행입니다\n심리상담 챗봇을 이용해보아요"
        }
    }
    
    private func emotionDiagnosis(in size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.gray.opacity(0.6))
                .frame(width: .infinity, height: size.height * 0.3)
            VStack(spacing: 10) {
                Text(diagnosedEmotion).font(.system(size: 70))
                Text(diagnosisMessage)
                    .padding()
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding()
    }
    
    @State private var selectedDate = Date()
    @State private var selectedEmotion = ""
    
    private var calendar: some View {
        VStack {
            DatePicker("이 주의 감정들", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: selectedDate) { value in
                    let date = dateToString(selectedDate: value)
                    if let value = testEmotionDatas[date] {
                        selectedEmotion = emotionValueToEmotion(value)
                    } else {
                        selectedEmotion = "기록이 없습니다"
                    }
                }
                .onAppear {
                    let date = dateToString(selectedDate: Date())
                    if let value = testEmotionDatas[date] {
                        selectedEmotion = emotionValueToEmotion(value)
                    } else {
                        selectedEmotion = "기록이 없습니다"
                    }
                }
                .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                .padding()
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.black.opacity(0.8))
                Text("\(dateToString(selectedDate: selectedDate))일의 감정: \(selectedEmotion)")
                    .font(.body)
                    .foregroundStyle(.white)
            }
            .padding()
        }
    }
    
    private func dateToString(selectedDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
    
    private var testEmotionDatas: [String:Double] = [
        "2024-04-08" : -0.6,
        "2024-04-09" : -0.6,
        "2024-04-10" : 0.2,
    ]
    
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
}

#Preview {
    EmotionRecord()
}
