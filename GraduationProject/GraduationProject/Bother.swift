//
//  Bother.swift
//  GraduationProject
//
//  Created by a mystic on 9/13/24.
//

import SwiftUI
import CoreML

struct Bother: View {
    @ObservedObject private var emotionManager = FaceEmotionManager.shared
    @EnvironmentObject var contentsManager: ContentsManager
    
    @Binding var showNext: Bool
    @Binding var showBother: Bool

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                if faceMode {
                    RoundedRectangle(cornerRadius: 12)
                        .scaleEffect(1.05)
                        .foregroundStyle(emotionManager.currentColor)
                }
                RoundedRectangle(cornerRadius: 12)
                    .scaleEffect(1.05)
                    .foregroundStyle(.ultraThinMaterial)
                if faceMode {
                    VStack {
                        FacialExpressionView().frame(width: 1, height: 1).opacity(0)
                        recordingStatus
                    }
                } else {
                    VStack(spacing: 70) {
                        countdownAnimation(in: geometry.size).scaleEffect(1.3)
                        Text("오늘 하루 있었던 일들을 얼굴 표정에 나타내주세요")
                            .font(.title)
                    }
                }
            }
            .padding(.horizontal)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                    withAnimation {
                        isTimerShow = true
                    }
                }
            }
        }
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
    
    private func recommendContent() {
        contentsManager.setSentimentValue(to: emotionManager.faceEmotionValue)
        if let model = try? SnoozeModel(configuration: MLModelConfiguration()),
           let contentLabel = try? model.prediction(input: .init(Emotion_value: emotionManager.faceEmotionValue)),
           let recommendedCategory = contentsLabel[Int(contentLabel.Content.rounded())] {
            contentsManager.setRecommendCategory(to: recommendedCategory)
            var mainCategory = ""
            for item in contentsCategories.keys {
                if let detailCategory = contentsCategories[item], detailCategory.contains(recommendedCategory) {
                    mainCategory = item
                }
            }
            if emotionManager.faceEmotionValue >= 0 {
                if selectedPositiveCategories.contains(mainCategory) {
                    if let content = selectedPositiveDetails[mainCategory]?.randomElement() {
                        contentsManager.setRecommendContent(to: content)
                    }
                } else {
                    contentsManager.setNeedHate(to: true)
                }
                if ["산책", "운동", "쇼핑"].contains(recommendedCategory) {
                    contentsManager.setRecommendCategory(to: "야외활동")
                    contentsManager.setRecommendContent(to: recommendedCategory)
                }
            } else if emotionManager.faceEmotionValue <= 0 {
                if selectedNegativeCategories.contains(mainCategory) {
                    if let content = selectedNegativeDetails[mainCategory]?.randomElement() {
                        contentsManager.setRecommendContent(to: content)
                    }
                } else {
                    contentsManager.setNeedHate(to: true)
                }
                if ["산책", "운동", "쇼핑"].contains(recommendedCategory) {
                    contentsManager.setRecommendCategory(to: "야외활동")
                    contentsManager.setRecommendContent(to: recommendedCategory)
                }
            }
        }
    }
    
    @State private var currentStatus = RecordingStatus.isNotRecording
    
    private enum RecordingStatus: String {
        case isRecording = "감정을 분석하는중 입니다."
        case isNotRecording = "감정을 분석하고 있지 않습니다."
    }
    
    private var recordingStatus: some View {
        VStack {
            Text(emotionManager.currentEmotion)
                .font(.system(size: 150))
            Text(currentStatus.rawValue)
                .font(.callout)
                .foregroundStyle(.white)
        }
        .padding()
        .padding(.horizontal)
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 4.5) {
                saveDiary()
                withAnimation {
                    emotionManager.stopAnalyzing()
                    showBother = false
                }
                recommendContent()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    withAnimation {
                        showNext = true
                    }
                }
            }
        }
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
    
    @State private var count = 5
    @State private var isTimerShow = false
    @State private var countdownAngle: Double = 0
    
    @ViewBuilder
    private func countdownAnimation(in size: CGSize) -> some View {
        if isTimerShow {
            Text("\(count)")
                .font(.largeTitle)
                .foregroundStyle(.black)
                .background {
                    Pie(endAngle: .degrees(countdownAngle * 360))
                        .foregroundStyle(.brown.opacity(0.5))
                        .frame(width: size.width * 0.2, height: size.height * 0.2)
                }
                .onAppear {
                    startCountdown()
                }
        }
    }
    
    @State private var faceMode = false
    
    private func startCountdown() {
        // test
        emotionManager.reset()
        contentsManager.reset()
        withAnimation(.linear(duration: 1)) {
            countdownAngle = 1
        }
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { timer in
            countdownAngle = 0
            count -= 1
            if count == 0 {
                timer.invalidate()
                isTimerShow = false
                faceMode = true
                currentStatus = .isRecording
                emotionManager.startAnalyzing()
            }
            withAnimation(.linear(duration: 1)) {
                countdownAngle = 1
            }
        }
    }
    
    @State private var recordedDiarys: [Diary] = []
    @AppStorage("recordedDiarys") var recordedDiarysAppStorage = Data()
    
    private func saveDiary() {
        decodeDiary()
        if let index = recordedDiarys.firstIndex(where: { $0.date == currentDate }) {
            recordedDiarys[index] = Diary(date: currentDate, emotionValue: emotionManager.faceEmotionValue, content: "이날은 입력하기 귀찮았어요")
        } else {
            recordedDiarys.append(Diary(date: currentDate, emotionValue: emotionManager.faceEmotionValue, content: "이날은 입력하기 귀찮았어요"))
        }
        if let data = try? JSONEncoder().encode(recordedDiarys) {
            recordedDiarysAppStorage = data
        }
    }
    
    private func decodeDiary() {
        if let data = try? JSONDecoder().decode([Diary].self, from: recordedDiarysAppStorage) {
            recordedDiarys = data
        }
    }
}

#Preview {
    Bother(showNext: .constant(false), showBother: .constant(false))
}
