//
//  Home.swift
//  GraduationProject
//
//  Created by a mystic on 10/11/23.
//

import SwiftUI

struct HaruDiary: View {
    @EnvironmentObject var emotionManager: FaceEmotionManager
    
    @State private var showDescription = false
    @State private var showRecommendedContent = false
    @State private var loginIsNeed = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack(spacing: 30) {
                    inputField
                    recordingStatus
                    analyze
                }
                ProgressView()
                    .scaleEffect(2)
                    .opacity(isFetching ? 1 : 0)
                FacialExpressionView()
                    .frame(width: 100, height: 100)
                    .opacity(0)
            }
            .navigationDestination(isPresented: $showRecommendedContent) {
                ContentRecommender(recommendedContent: recommendedContent, sentimentValue: sentimentValue)
            }
            .navigationTitle("Snooze")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        showDescription = true
                    } label: {
                        Image(systemName: "questionmark.circle")
                    }
                }
            }
        }
        .sheet(isPresented: $showDescription) {
            Description()
        }
        .fullScreenCover(isPresented: $loginIsNeed) {
            LoginView(loginIsNeeded: $loginIsNeed)
        }
    }
    
    private var background: some View {
        Color.gray
            .opacity(0.1)
            .ignoresSafeArea(edges: .bottom)
            .onTapGesture {
                isFocused = false
                currentStatus = .isNotRecording
                emotionManager.stopAnalyzing()
            }
    }
    
    @State private var inputs = ""
    
    @FocusState private var isFocused: Bool
    
    private var inputField: some View {
        TextEditor(text: $inputs)
            .textFieldStyle(.roundedBorder)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled(true)
            .frame(width: 300, height: 250)
            .shadow(radius: 10)
            .focused($isFocused)
            .onTapGesture {
                currentStatus = .isRecording
                emotionManager.startAnalyzing()
            }
    }
    
    private var analyze: some View {
        Button {
//            Task {
//                await analyzeHaru()
//            }
            // test
            isFetching = true
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                isFetching = false
                showRecommendedContent = true
            }
        } label: {
            Text("Analyze")
                .frame(maxWidth: .infinity)
        }
        .padding(.horizontal)
        .buttonStyle(.borderedProminent)
    }
    
    struct ContentsData: Codable {
        var recommend: String
        var sentimentValue: Double
        var category: String
    }

    @State private var recommendedContent = ""
    @State private var sentimentValue: Double = 0
    @State private var isFetching = false

    private func analyzeHaru() async {
        isFetching = true
        let url = "http://127.0.0.1:8000/recommend?inputText=\(inputs)&faceEmotionValue=\(Double(0.2))"
        guard let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodingUrl) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let responseData = try JSONDecoder().decode(ContentsData.self, from: data)
            recommendedContent = responseData.recommend
            sentimentValue = responseData.sentimentValue
            isFetching = false
            currentStatus = .isNotRecording
            showRecommendedContent = true
        } catch {
            print(error)
        }
    }
    
    @State private var currentStatus = RecordingStatus.isNotRecording
    
    private enum RecordingStatus: String {
        case isRecording = "감정을 분석하는중 입니다."
        case isNotRecording = "감정을 분석하고 있지 않습니다."
    }
    
    private var recordingStatus: some View {
        HStack {
            Text(currentStatus.rawValue)
            Text(emotionManager.currentEmotion)
                .font(.largeTitle)
        }
        .foregroundStyle(emotionManager.currentColor)
        .font(.callout)
    }
}

#Preview {
    HaruDiary()
        .environmentObject(FaceEmotionManager())
}
