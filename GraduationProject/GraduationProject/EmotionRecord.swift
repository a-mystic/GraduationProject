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
            Form {
                Section {
                    emotionDiagnosis(in: geometry.size)
                } header: {
                    Text("진단")
                        .foregroundStyle(.black)
                        .font(.title)
                }
                Section {
                    cards(in: geometry.size)
                } header: {
                    Text("최근 30일")
                        .foregroundStyle(.black)
                        .font(.title)
                }
            }
        }
        .onAppear {
            decodeDiary()
            // test
            makeDummyDiary()
            emotionChangeRatio = calcEmotionChangeRatio(recordedDiarysEmotionValues)
            emotionCoefficient = coefficientOfVariation(recordedDiarysEmotionValues)
            makeDiagnosisEmotion()
            makeDiagnosisMessage()
            makeDetailMessage()
        }
    }
    
    @State private var emotionChangeRatio: Double = 0
    @State private var emotionCoefficient: Double = 0
    @State private var diagnosedEmotion: String = ""
    @State private var diagnosisMessage: String = ""
    
    private func calcEmotionChangeRatio(_ emotions: [Double]) -> Double {
        var lhs: Double = 0
        if let firstEmotion = emotions.first {
            lhs = firstEmotion
        }
        var find = 0
        for emotionValue in emotions {
            let rhs = emotionValue
            if (lhs * rhs) < 0 {
                find += 1
            }
            lhs = emotionValue
        }
        return Double(find) / Double(emotions.count)
    }
    
    private func coefficientOfVariation(_ emotions: [Double]) -> Double {
        if emotions.isEmpty {
            return 0
        } else {
            let variance = emotions.map { pow($0 - emotions.mean(), 2) }.reduce(0, +) / Double(emotions.count)
            return abs(sqrt(variance) / emotions.mean())
        }
    }
    
    private func makeDiagnosisEmotion() {
        if emotionChangeRatio > 0.3 || emotionCoefficient > 0.5 {
            diagnosedEmotion = "😱"
            return
        } else {
            if recordedDiarysEmotionValues.isEmpty {
                diagnosedEmotion = "📂"
                return
            } else {
                diagnosedEmotion = emotionValueToEmotion(recordedDiarysEmotionValues.mean())
                return 
            }
        }
    }
    
    private func makeDiagnosisMessage() {
        if recordedDiarysEmotionValues.isEmpty {
            diagnosisMessage = "기록이 존재하지 않아요."
            return
        }
        if emotionChangeRatio > 0.3 || emotionCoefficient > 0.5 {
            diagnosisMessage = "최근 한달간 감정기복이 심해요\n심리상담 챗봇을 이용해요"
            return
        }
        if recordedDiarysEmotionValues.mean() > 0 {
            diagnosisMessage = "최근 한달간 느끼신 감정은 행복입니다"
            return
        } else {
            diagnosisMessage = "최근 한달간 느끼신 감정은 불행입니다\n심리상담 챗봇을 이용해요"
            return
        }
    }
    
    @State private var selectedPickerStatus: PickerStatus = .summary
    private let pickerStatuses: [PickerStatus] = [.summary, .detail]
    
    private func emotionDiagnosis(in size: CGSize) -> some View {
        VStack {
            Picker("선택", selection: $selectedPickerStatus) {
                ForEach(pickerStatuses, id: \.self) { state in
                    Text(state.rawValue)
                }
            }
            .pickerStyle(.segmented)
            .padding(.horizontal)
            Spacer()
            ZStack {
                if selectedPickerStatus == .summary {
                    VStack(spacing: 0) {
                        Spacer()
                        Text(diagnosedEmotion).font(.system(size: 150))
                        Spacer()
                        Text(diagnosisMessage)
                            .font(.title3)
                            .padding()
                            .background(Color.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
                        Spacer()
                    }
                }
                if selectedPickerStatus == .detail {
                    emotionChart(in: size)
                }
            }
        }
        .frame(width: size.width * 0.9, height: size.height * 0.6)
        .padding()
    }
    
    private func makeDateSimply(_ date: String) -> String {
        let originalFormatter = DateFormatter()
        originalFormatter.dateFormat = "yyyy-MM-dd"
        let simpleFormatter = DateFormatter()
        simpleFormatter.dateFormat = "MM/dd"
        if let original = originalFormatter.date(from: date) {
            return simpleFormatter.string(from: original)
        }
        return ""
    }
    
    @State private var detailMessage = ""
    @State private var chartDatas: [String:Double] = [:]
    
    private func emotionChart(in size: CGSize) -> some View {
        VStack(spacing: 30) {
            Chart(chartDatas.sorted(by: { $0.key < $1.key }), id: \.key) { data in
                LineMark(x: .value("날짜", makeDateSimply(data.key)), y: .value("감정수치", data.value))
            }
            .foregroundStyle(.black)
            .onAppear {
                var delay = 0.0
                for data in recordedDiarys.sorted(by: { $0.date < $1.date }) {
                    DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            chartDatas[data.date] = data.emotionValue
                        }
                    }
                    delay += 0.2
                }
            }
            Text(detailMessage)
                .font(.caption)
                .padding()
                .background(Color.gray.opacity(0.15), in: RoundedRectangle(cornerRadius: 6))
        }
        .padding()
    }
    
    private func makeDetailMessage() {
        let mean = recordedDiarysEmotionValues.mean()
        let absSum = recordedDiarysEmotionValues.reduce(0) { lhs, rhs in
            abs(lhs) + abs(rhs)
        }
        let negatives = recordedDiarysEmotionValues.filter { value in
            value < 0
        }
        let negativeSum = negatives.reduce(0) { lhs, rhs in
            abs(lhs) + abs(rhs)
        }
        let negativeRatio = negativeSum / absSum
        let positives = recordedDiarysEmotionValues.filter { value in
            value > 0
        }
        let positiveSum = positives.reduce(0) { lhs, rhs in
            abs(lhs) + abs(rhs)
        }
        let positiveRatio = positiveSum / absSum
        if mean > 0 {
            detailMessage = "최근 한 달간 감정 수치들의 평균은 \(String(format: "%.2f", mean))으로 감정이 긍정적이었어요.\n그중 \(String(format: "%.2f", positiveRatio * 100))%는 긍정적인 감정이에요."
            if emotionChangeRatio > 0.3 || emotionCoefficient > 0.5 {
                var lhs: Double = 0
                if let firstEmotion = recordedDiarysEmotionValues.first {
                    lhs = firstEmotion
                }
                var emotionChangeCount = 0
                for emotionValue in recordedDiarysEmotionValues[1..<recordedDiarysEmotionValues.count] {
                    let rhs = emotionValue
                    if (lhs * rhs) < 0 {
                        emotionChangeCount += 1
                    }
                    lhs = emotionValue
                }
                detailMessage = "최근 한 달간 감정 수치들의 평균은 \(String(format: "%.2f", mean))으로 감정이 긍정적이었어요.\n그중 \(String(format: "%.2f", positiveRatio * 100))%는 긍정적인 감정이에요.\n하지만 감정이 기록된 \(recordedDiarys.count)일 중 감정기복의 횟수가 \(emotionChangeCount)번으로 안좋게 나타났어요."
            }
        } else {
            detailMessage = "최근 한 달간 감정 수치들의 평균은 \(String(format: "%.2f", mean))으로 감정이 부정적이었어요.\n그중 \(String(format: "%.2f", negativeRatio * 100))%는 부정적인 감정이에요."
            if emotionChangeRatio > 0.3 || emotionCoefficient > 0.5 {
                var lhs: Double = 0
                if let firstEmotion = recordedDiarysEmotionValues.first {
                    lhs = firstEmotion
                }
                var emotionChangeCount = 0
                for emotionValue in recordedDiarysEmotionValues[1..<recordedDiarysEmotionValues.count] {
                    let rhs = emotionValue
                    if (lhs * rhs) < 0 {
                        emotionChangeCount += 1
                    }
                    lhs = emotionValue
                }
                detailMessage = "최근 한 달간 감정 수치들의 평균은 \(String(format: "%.2f", mean))으로 감정이 부정적이었어요.\n그중 \(String(format: "%.2f", negativeRatio * 100))%는 부정적인 감정이에요.\n거기에 더해서 감정이 기록된 \(recordedDiarys.count)일 중 감정기복의 횟수가 \(emotionChangeCount)번으로 안좋게 나타났어요."
            }
        }
        if recordedDiarys.isEmpty {
            detailMessage = "기록이 존재하지 않아요."
        }
    }
    
    private func dateToString(selectedDate: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: selectedDate)
    }
    
    @State private var recordedDiarys: [Diary] = []
    @AppStorage("recordedDiarys") var recordedDiarysAppStorage = Data()
    
    private var recordedDiarysEmotionValues: [Double] {
        var values: [Double] = []
        var days: [String] = []
        for day in recordedDiarys {
            days.append(day.date)
        }
        days = days.sorted(by: <)
        for day in days {
            if let value = recordedDiarys.first(where: { $0.date == day })?.emotionValue {
                values.append(value)
            }
        }
        return values
    }
    
    @State private var showDetail = false
    @State private var selectedDate = ""
    
    @ViewBuilder
    private func cards(in size: CGSize) -> some View {
        let gridItemSize = gridItemWidthThatFits(count: recordedDiarys.count, size: size, atAspectRatio: 1.0)
        ScrollView {
            LazyVGrid(
                columns: [
                    GridItem(.adaptive(minimum: gridItemSize), spacing: 10),
                    GridItem(.adaptive(minimum: gridItemSize), spacing: 10)
                ],
                spacing: 10
            ) {
                ForEach(recordedDiarys.sorted(by: { $0.date < $1.date }), id: \.date) { diary in
                    ZStack {
                        RoundedRectangle(cornerRadius: 14)
                            .foregroundStyle(emotionValueToColor(diary.emotionValue))
                        VStack {
                            Text(emotionValueToEmotion(diary.emotionValue))
                                .font(.system(size: 50))
                            Text(diary.content)
                                .font(.body)
                                .lineLimit(2)
                        }
                        .padding()
                        .padding(.vertical)
                    }
                    .onTapGesture {
                        selectedDate = diary.date
                        showDetail = true
                    }
                }
            }
            .sheet(isPresented: $showDetail) {
                DetailRecord(selectedDate: $selectedDate)
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
    
    private func emotionValueToColor(_ value: Double) -> Color {
        if value <= 1 && value > 0.5 {
            return .orange
        } else if value <= 0.5 && value > 0 {
            return .orange.opacity(0.5)
        } else if value == 0 {
            return .gray.opacity(0.5)
        } else if value >= -0.5 && value < 0 {
            return .cyan.opacity(0.5)
        } else if value >= -1 && value < -0.5 {
            return .cyan
        }
        return .gray.opacity(0.5)
    }
    
    private enum PickerStatus: String {
        case summary = "Summary"
        case detail = "Detail"
    }
    
    private func gridItemWidthThatFits(
        count: Int,
        size: CGSize,
        atAspectRatio aspectRatio: CGFloat
    ) -> CGFloat {
        let count = CGFloat(count)
        var columnCount = 1.0
        repeat {
            let width = size.width / columnCount
            let height = width / aspectRatio
            
            let rowCount = (count / columnCount).rounded(.up)
            if rowCount * height < size.height {
                return (size.width / columnCount).rounded(.up)
            }
            columnCount += 1
        } while columnCount < count
        return min(size.width / count, size.height * aspectRatio).rounded(.down)
    }
    
    private func decodeDiary() {
        if let data = try? JSONDecoder().decode([Diary].self, from: recordedDiarysAppStorage) {
            recordedDiarys = data
        }
    }
    
    // test
    private var testEmotionDatas: [String:Double] = [
        "2024-10-20" : -0.1,
        "2024-10-23" : 0.2,
        "2024-10-25" : -0.3,
        "2024-10-27" : 0.6,
        "2024-10-29" : -0.5,
        "2024-10-30" : 0,
        "2024-11-04" : -0.66,
    ]
    
    private func makeDummyDiary() {
        // test
//        if recordedDiarys.count == 1 {
            for data in testEmotionDatas {
                if let index = recordedDiarys.firstIndex(where: { $0.date == data.key }) {
                    recordedDiarys[index] = Diary(date: data.key, emotionValue: data.value, content: "이 일지는 \(data.key)일에 작성된 테스트 일지입니다.")
                } else {
                    recordedDiarys.append(Diary(date: data.key, emotionValue: data.value, content: "이 일지는 \(data.key)일에 작성된 테스트 일지입니다."))
                }
            }
            if let data = try? JSONEncoder().encode(recordedDiarys) {
                recordedDiarysAppStorage = data
            }
//        }
    }
}

#Preview {
    EmotionRecord()
}
