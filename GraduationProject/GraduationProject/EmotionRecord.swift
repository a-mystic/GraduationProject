//
//  EmotionRecord.swift
//  GraduationProject
//
//  Created by a mystic on 4/9/24.
//

import SwiftUI
import Charts

struct EmotionRecord: View {
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 0) {
                    emotionDiagnosis(in: geometry.size)
                    emotionChart(in: geometry.size)
                    calendar
                }
            }
        }
    }
    
    private var diagnosedEmotion: String {
        emotionValueToEmotion(testEmotionDatas.values.mean())
    }
    
    private var diagnosisMessage: String {
        let mean = testEmotionDatas.values.mean()
        if mean > 0 {
            return "최근 일주일간 느끼신 감정은 행복입니다"
        } else {
            return "최근 일주일간 느끼신 감정은 불행입니다\n심리상담 챗봇을 이용해보아요"
        }
    }
    
    private func emotionDiagnosis(in size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.gray.opacity(0.6))
                .frame(width: size.width * 0.9, height: size.height * 0.3)
            VStack(spacing: 10) {
                Text(diagnosedEmotion).font(.system(size: 70))
                Text(diagnosisMessage)
                    .padding()
                    .background(Color.white, in: RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding()
    }
    
    private var weekPercent: Double {
        let absSum = testEmotionDatas.values.reduce(0) { lhs, rhs in
            abs(lhs) + abs(rhs)
        }
        let sum = testEmotionDatas.values.reduce(0) { lhs, rhs in
            lhs + rhs
        }
        return (absSum - sum) / absSum  
    }
    
    private func emotionChart(in size: CGSize) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.brown.opacity(0.5))
            Circle()
                .stroke(lineWidth: 15)
                .foregroundStyle(.gray)
                .padding()
            Circle()
                .trim(from: 0, to: 0.9)
                .stroke(lineWidth: 16)
                .rotation(Angle(degrees: -90))
                .foregroundStyle(.black)
                .padding()
            Text("90%")
        }
        .frame(width: size.width * 0.9, height: size.height * 0.4)
        .padding()
    }
    
    @State private var selectedDate = Date()
    @State private var selectedEmotion = ""
    
    private var calendar: some View {
        VStack {
            DatePicker("이 주의 감정들", selection: $selectedDate, displayedComponents: .date)
                .datePickerStyle(GraphicalDatePickerStyle())
                .onChange(of: selectedDate) { value in
                    makeCalendarData(value)
                }
                .onAppear {
                    makeCalendarData(Date())
                }
                .background(.gray.opacity(0.2), in: RoundedRectangle(cornerRadius: 12))
                .padding()
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.black.opacity(0.8))
                Text("\(dateToString(selectedDate: selectedDate))일의 감정: \(selectedEmotion)")
                    .padding()
                    .font(.body)
                    .foregroundStyle(.white)
            }
            .padding()
        }
    }
    
    private func makeCalendarData(_ date: Date) {
        let date = dateToString(selectedDate: date)
        if let value = testEmotionDatas[date] {
            selectedEmotion = emotionValueToEmotion(value)
        } else {
            selectedEmotion = "기록이 없습니다"
        }
    }
    
    private func dateToString(selectedDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
    
    private var testEmotionDatas: [String:Double] = [
        "2024-05-01" : -0.1,
        "2024-05-02" : -0.2,
        "2024-05-03" : 0.3,
        "2024-05-04" : 0.4,
        "2024-05-05" : -0.5,
        "2024-05-06" : -0.2,
        "2024-05-07" : -0.66,
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
