//
//  AskView.swift
//  GraduationProject
//
//  Created by a mystic on 3/13/24.
//

import SwiftUI
import CoreML

struct AskView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject private var emotionManager = FaceEmotionManager.shared
    @EnvironmentObject var contentsManager: ContentsManager
    
    @State private var action = ""
    @State private var emotion = ""
    @State private var showEmotionSelector = false

    @Binding var showNext: Bool
        
    var body: some View {
        if !showEmotionSelector {
            VStack(spacing: 30) {
                Spacer()
                emotionBar
                ask
                yesOrNo
                Spacer()
                FacialExpressionView().frame(width: 1, height: 1).opacity(0)
                recordingStatus
            }
            .onAppear {
                makeAsk(for: contentsManager.sentimentValue)
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    currentStatus = .isRecording
                    emotionManager.startAnalyzing()
                }
            }
        } else {
            VStack {
                Spacer()
                emotionSelector
                Spacer()
                check
            }
        }
    }
    
    @State private var emotionBarAnimationValue: Double = 0
    
    @ViewBuilder
    private var emotionBar: some View {
        let emotion = contentsManager.sentimentValue > 0 ? "긍정수치" : "부정수치"
        VStack {
            Text("\(String(format: "%.f", emotionBarAnimationValue*100))%")
            HStack {
                Text("\(emotion)")
                ProgressView(value: emotionBarAnimationValue, total: 1)
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .onAppear {
                Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { timer in
                    if emotionBarAnimationValue >= abs(contentsManager.sentimentValue) {
                        timer.invalidate()
                    } else {
                        DispatchQueue.global(qos: .background).async {
                            emotionBarAnimationValue += 0.01
                        }
                    }
                }
            }
            .padding(.vertical, 10)
            notice
        }
    }
    
    private var notice: some View {
        Text("* 위 결과는 Naver Sentiment API를 사용하여 얻어진 수치입니다.")
            .underline()
            .font(.caption)
            .foregroundStyle(.gray)
    }
    
    private var ask: some View {
        Text("오늘 \(action)일이 있었고 이때 \(emotion) 감정을 느끼신것이 맞나요?")
            .bold()
            .padding()
            .padding()
            .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 12))
    }
    
    private func makeAsk(for value: Double) {
        if value >= 0 {
            action = "좋은"
            emotion = "행복한"
        } else {
            action = "안좋은"
            emotion = "불행한"
        }
    }
    
    private var yesOrNo: some View {
        HStack(spacing: 20) {
            yes
            no
        }
        .frame(height: 70)
        .padding(.horizontal)
        .padding(.horizontal)
    }
    
    private var yes: some View {
        Button {
            emotionManager.stopAnalyzing()
            recommendContent(by: contentsManager.sentimentValue, answer: .yes)
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showNext = true
                }
            }
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.blue.opacity(0.5))
                .overlay {
                    Text("네")
                        .foregroundStyle(.white)
                }
        }
    }
    
    private var no: some View {
        Button {
            emotionManager.stopAnalyzing()
            withAnimation {
                showEmotionSelector = true
            }
        } label: {
            RoundedRectangle(cornerRadius: 12)
                .foregroundStyle(.red.opacity(0.5))
                .overlay {
                    Text("아니오")
                        .foregroundStyle(.white)
                }
        }
    }
    
    private let emotions = ["🙂 기쁨", "🥲 슬픔", "😠 화남", "😐 중간"]
    @State private var selectedEmotion = ""
    
    private var emotionSelector: some View {
        VStack(spacing: 25) {
            Text("아래의 감정중 오늘느낀 감정을 선택해주세요")
            VStack(spacing: 25) {
                ForEach(emotions, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(item == selectedEmotion ? .black : .gray)
                        .frame(width: 300, height: 50)
                        .overlay {
                            Text(item)
                                .foregroundStyle(item == selectedEmotion ? .black : .gray)
                                .font(.title2)
                        }
                        .onTapGesture {
                            selectedEmotion = item
                        }
                }
            }
            .padding()
        }
    }
    
    private var selectedEmotionValue: Double {
        switch selectedEmotion {
        case "🙂 기쁨":
            return 0.7
        case "🥲 슬픔":
            return -0.8
        case "😠 화남":
            return -0.5
        case "😐 중간":
            return 0
        default:
            return 0.7
        }
    }
    
    private var check: some View {
        Button {
            contentsManager.setSentimentValue(to: selectedEmotionValue)
            recommendContent(by: contentsManager.sentimentValue, answer: .no)
            dismiss()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                withAnimation {
                    showNext = true
                }
            }
        } label: {
            Text("선택완료")
                .frame(maxWidth: .infinity, maxHeight: 30)
        }
        .padding()
        .padding(.horizontal)
        .buttonStyle(.borderedProminent)
    }
    
    private var sumOfEmotionValues: Int {
        var sum = 0
        emotionManager.faceEmotions.values.forEach { value in
            sum += value
        }
        return sum
    }
    
    private enum AnswerState {
        case yes
        case no
    }
    
    @AppStorage("selectedPositiveCategoriesAppStorage") var selectedPositiveCategoriesAppStorage = Data()
    @AppStorage("selectedNegativeCategoriesAppStorage") var selectedNegativeCategoriesAppStorage = Data()
    @AppStorage("selectedPositiveDetailsAppStorage") var selectedPositiveDetailsAppStorage = Data()
    @AppStorage("selectedNegativeDetailsAppStorage") var selectedNegativeDetailsAppStorage = Data()

    
    private var selectedPositiveCategories: [String] {
        if let data = try? JSONDecoder().decode([String].self, from: selectedPositiveCategoriesAppStorage) {
            return data
        }
        return []
    }
    
    private var selectedNegativeCategories: [String] {
        if let data = try? JSONDecoder().decode([String].self, from: selectedNegativeCategoriesAppStorage) {
            return data
        }
        return []
    }
    
    private var selectedPositiveDetails: [String:[String]] {
        if let data = try? JSONDecoder().decode([String:[String]].self, from: selectedPositiveDetailsAppStorage) {
            return data
        }
        return [:]
    }
    
    private var selectedNegativeDetails: [String:[String]] {
        if let data = try? JSONDecoder().decode([String:[String]].self, from: selectedNegativeDetailsAppStorage) {
            return data
        }
        return [:]
    }
    
    private let CategoryDetails: [String:[String]] = [
        "영상시청" : ["코미디", "모험", "다큐멘터리", "과학", "역사"],
        "음악" : ["발라드", "케이팝", "팝송", "클래식"],
        "책" : ["추리소설", "인문학", "심리학", "과학", "공학", "컴퓨터"],
        "야외활동": ["산책", "쇼핑", "운동"]
    ]
    
    private let contentsCategories: [String:[String]] = [
        "영상시청" : ["영화", "유튜브"],
        "음악" : ["음악"],
        "책" : ["책"],
        "야외활동" : ["산책", "운동", "쇼핑"]
    ]
    
    private func recommendContent(by value: Double, answer: AnswerState) {
        let emotionValue = createAdvancedEmotionValue(value, answer: answer)
        if let model = try? SnoozeModel(configuration: MLModelConfiguration()),
           let contentLabel = try? model.prediction(input: .init(Emotion_value: emotionValue)),
           let recommendedCategory = contentsLabel[Int(contentLabel.Content.rounded())] {
            contentsManager.setRecommendCategory(to: recommendedCategory)
            var mainCategory = ""
            for item in contentsCategories.keys {
                if let detailCategory = contentsCategories[item], detailCategory.contains(recommendedCategory) {
                    mainCategory = item
                }
            }
            
            if value >= 0 {
                if selectedPositiveCategories.contains(mainCategory) {
                    if let content = selectedPositiveDetails[mainCategory]?.randomElement() {
                        contentsManager.setRecommendContent(to: content)
                    }
                } else {
                    contentsManager.setNeedHate(to: true)
                }
            } else if value <= 0 {
                if selectedNegativeCategories.contains(mainCategory) {
                    if let content = selectedNegativeDetails[mainCategory]?.randomElement() {
                        contentsManager.setRecommendContent(to: content)
                    }
                } else {
                    contentsManager.setNeedHate(to: true)
                }
            }
        }
    }
    
    private func createAdvancedEmotionValue(_ value: Double, answer: AnswerState) -> Double {
        let emotionPositiveAmount = Double(emotionManager.isPositive) / Double(sumOfEmotionValues)
        var finalEmotionValue: Double = 0
        if sumOfEmotionValues == 0 || !((answer == .yes && emotionPositiveAmount > 0) || (answer == .no && emotionPositiveAmount < 0)) {
            if sumOfEmotionValues == 0 {
                return value
            }
            if answer == .yes && emotionPositiveAmount < 0 {
                if contentsManager.sentimentValue > 0 {
                    finalEmotionValue = contentsManager.sentimentValue * 0.8 + emotionPositiveAmount * 0.2
                } else {
                    finalEmotionValue = contentsManager.sentimentValue * 0.8 + emotionPositiveAmount * -0.2
                }
            } else if answer == .no && emotionPositiveAmount > 0 {
                if contentsManager.sentimentValue > 0 {
                    finalEmotionValue = contentsManager.sentimentValue * 0.8 + emotionPositiveAmount * -0.2
                } else {
                    finalEmotionValue = contentsManager.sentimentValue * 0.8 + emotionPositiveAmount * 0.2
                }
            }
            return finalEmotionValue
        }
        return value
    }
    
    @State private var currentStatus = RecordingStatus.isNotRecording
    
    private enum RecordingStatus: String {
        case isRecording = "감정을 분석하는중 입니다."
        case isNotRecording = "감정을 분석하고 있지 않습니다."
    }
    
    private var recordingStatus: some View {
        HStack {
            Text(emotionManager.currentEmotion).font(.largeTitle)
            Text(currentStatus.rawValue).font(.callout).foregroundStyle(.white)
        }
        .padding()
        .padding(.horizontal)
        .background(emotionManager.currentColor.opacity(0.6), in: RoundedRectangle(cornerRadius: 20))
    }
    
    private let contentsLabel: [Int:String] = [
        0 : "영화",
        1 : "책",
        2 : "음악",
        3 : "산책",
        4 : "운동",
        5 : "유튜브",
        6 : "쇼핑"
    ]
}

#Preview {
    AskView(showNext: .constant(false))
        .environmentObject(ContentsManager())
}
