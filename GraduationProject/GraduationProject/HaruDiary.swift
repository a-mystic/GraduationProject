//
//  Home.swift
//  GraduationProject
//
//  Created by a mystic on 10/11/23.
//

import SwiftUI
import CoreML
import CoreLocation

struct HaruDiary: View {
    @Binding var serverState: ServerState
    
    init(serverState: Binding<ServerState>) {
        _serverState = serverState
    }
    
    @State private var showDescription = false
    @State private var showRecommendedContent = false
    @State private var loginIsNeed = false
    @State private var userInfoIsNeed = false
    
    private var locationManager = LocationManager.manager
    
    var body: some View {
        NavigationStack {
            Group {
                if serverState == .good && !todayUse {
                    diary
                } else if serverState == .bad {
                    disconnectionView
                } else if serverState == .loading {
                    loading
                } else if todayUse {
                    alreadyUseView
                }
            }
            .transition(.scale)
            .navigationDestination(isPresented: $showRecommendedContent) {
                ContentRecommender()
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
            .alert("Error", isPresented: $showDiaryError) { }
        }
        .onAppear {
            Task {
                await checkServer()
                diaryFiltering()
                // test
//                checktodayUse()
            }
        }
        .sheet(isPresented: $showDescription) {
            Description()
        }
        .fullScreenCover(isPresented: $userInfoIsNeed) {
            InputUserInfo(isShow: $userInfoIsNeed)
        }
        .onChange(of: locationManager.locationManager.authorizationStatus) { _ in
            if locationManager.locationManager.authorizationStatus == .authorizedWhenInUse ||
                locationManager.locationManager.authorizationStatus == .authorizedAlways {
                getCurrentLocation()
            }
        }
    }
    
    @State private var todayUse = false
    
    private func checktodayUse() {
        var find = false
        for diary in recordedDiarys {
            if currentDate == diary.date {
                find = true
            }
        }
        todayUse = find
    }
    
    private var diary: some View {
        ZStack {
            background
            VStack(spacing: 30) {
                inputField
                bother
                analyze
            }
            .overlay {
                ProgressView()
                    .scaleEffect(2)
                    .opacity(isFetching ? 1 : 0)
                if showBother {
                    Bother(showNext: $showRecommendedContent, showBother: $showBother)
                        .transition(.move(edge: .bottom))
                }
            }
        }
    }
    
    private var disconnectionView: some View {
        ZStack {
            background
            VStack(spacing: 30) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 50))
                Text("서버와 연결상태가 원활하지 않아요.")
                    .bold()
            }
            .padding()
            .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 14))
        }
    }
    
    private func checkServer() async {
        let url = ServerUrls.check
        guard let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodingUrl) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let _ = try JSONDecoder().decode(Bool.self, from: data)
            serverState = .good
        } catch {
            serverState = .bad
        }
    }
    
    private var background: some View {
        Color.gray
            .opacity(0.1)
            .ignoresSafeArea(edges: .bottom)
            .onTapGesture {
                isFocused = false
            }
            .padding(.bottom)
    }
    
    @State private var inputText = ""
    
    @FocusState private var isFocused: Bool
    
    private var inputField: some View {
        TextField("진실한 감정으로 작성해주셔야 컨텐츠 추천에 용이해요", text: $inputText, axis: .vertical)
            .lineLimit(10...15)
            .padding()
            .background {
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.white)
                    .shadow(radius: 7)
            }
            .tint(.black)
            .foregroundStyle(.black)
            .padding()
            .focused($isFocused)
            .onChange(of: inputText, perform: { value in
                if let lastCharacter = value.last, lastCharacter.isEmoji, value.count >= 1000 {
                    inputText.removeLast()
                }
            })
    }
    
    @State private var showBother = false
    
    private var bother: some View {
        Button {
            // test
            contentsManager.reset()
            withAnimation(.easeInOut(duration: 2)) {
                showBother = true
            }
        } label: {
            RoundedRectangle(cornerRadius: 10)
                .foregroundStyle(.blue.opacity(0.5))
                .overlay {
                    Text("입력하기 귀찮아요")
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, maxHeight: 45)
        }
        .padding(.horizontal)
        .overlay {
            VStack {
                HStack {
                    Text("\(inputText.count)/1000").font(.footnote).foregroundStyle(.gray)
                    Spacer()
                }
                .padding()
                Spacer().frame(height: 80)
            }
        }
    }
    
    private var analyze: some View {
        Button {
            Task {
                if !inputText.isEmpty {
                    await analyzeHaru()
                }
            }
        } label: {
            Text("입력완료")
                .frame(maxWidth: .infinity, maxHeight: 30)
        }
        .padding(.horizontal)
        .buttonStyle(.borderedProminent)
        .sheet(isPresented: $showAskView) {
            AskView(showNext: $showRecommendedContent)
        }
    }
    
    struct SentimentData: Codable {
        var sentimentValue: Double
    }

    @State private var isFetching = false
    @State private var showAskView = false
    @State private var showDiaryError = false
    @State private var recordedDiarys: [Diary] = []
    
    @AppStorage("recordedDiarys") var recordedDiarysAppStorage = Data()
    
    @EnvironmentObject var contentsManager: ContentsManager

    private func analyzeHaru() async {
        isFetching = true
        let url = ServerUrls.sentimentValue + "?inputText=\(inputText)"
        guard let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodingUrl) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let responseData = try JSONDecoder().decode(SentimentData.self, from: data)
            contentsManager.setSentimentValue(to: responseData.sentimentValue)
            saveDiary()
            isFetching = false
            showAskView = true
        } catch {
            showDiaryError = true
        }
    }
    
    private func saveDiary() {
        decodeDiary()
        // if currentDate contain recordedDiarys
        if let index = recordedDiarys.firstIndex(where: { $0.date == currentDate }) {
            recordedDiarys[index] = Diary(date: currentDate, emotionValue: contentsManager.sentimentValue, content: inputText)
        } else {
            recordedDiarys.append(Diary(date: currentDate, emotionValue: contentsManager.sentimentValue, content: inputText))
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
    
    private func diaryFiltering() {
        decodeDiary()
        let currentDate = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let calendar = Calendar.current
        if let date30DaysAgo = calendar.date(byAdding: .day, value: -30, to: currentDate) {
            recordedDiarys = recordedDiarys.filter { diary in
                if let date = dateFormatter.date(from: diary.date) {
                    return date >= date30DaysAgo
                }
                return false
            }
        }
        if let data = try? JSONEncoder().encode(recordedDiarys) {
            recordedDiarysAppStorage = data
        }
    }
    
    private var alreadyUseView: some View {
        VStack(spacing: 30) {
            Text("☑️").font(.system(size: 50))
            Text("오늘은 이미 작성했어요. 내일 다시 작성 해주세요.")
        }
        .padding()
        .background(.gray.opacity(0.3), in: RoundedRectangle(cornerRadius: 14))
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
    
    private func getCurrentLocation() {
        if let latitude = locationManager.locationManager.location?.coordinate.latitude,
           let longitude = locationManager.locationManager.location?.coordinate.longitude {
            locationManager.latitude = latitude
            locationManager.longitude = longitude
        }
    }
    
    private var loading: some View {
        VStack(spacing: 50) {
            ProgressView().scaleEffect(2)
            Text("서버상태 확인중")
        }
    }
}

#Preview {
    HaruDiary(serverState: .constant(.good))
}
