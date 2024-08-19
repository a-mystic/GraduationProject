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
//    @AppStorage("userInputIsNeed") private var userInfoIsNeed = true
    @State private var userInfoIsNeed = false
    
    private var locationManager = LocationManager.manager
    
    var body: some View {
        NavigationStack {
            Group {
                if serverState == .good && !todayUse {
                    diary
                } else if serverState == .bad {
                    disconnectionView
                } else if todayUse {
                    alreadyUseView
                }
            }
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
                checktodayUse()
            }
        }
        .sheet(isPresented: $showDescription) {
            Description()
        }
        .sheet(isPresented: $userInfoIsNeed) {
            UserInfo(isShow: $userInfoIsNeed)
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
        todayUse = recordedDiarys.keys.contains(currentDate)
    }
    
    private var diary: some View {
        ZStack {
            background
            VStack(spacing: 30) {
                inputField
                analyze
            }
            .overlay {
                ProgressView()
                    .scaleEffect(2)
                    .opacity(isFetching ? 1 : 0)
            }
        }
    }
    
    private var disconnectionView: some View {
        ZStack {
            background
            VStack(spacing: 30) {
                Image(systemName: "wifi.slash")
                    .font(.system(size: 75))
                Text("서버와의 연결상태가 원활하지 않아요.")
                    .bold()
            }
        }
    }
    
    private func checkServer() async {
        let url = ServerUrls.check
        guard let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodingUrl) else { return }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let _ = try JSONDecoder().decode(Bool.self, from: data)
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
            .autocorrectionDisabled()
            .textInputAutocapitalization(.never)
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
    }
    
    private var analyze: some View {
        Button {
            Task {
                await analyzeHaru()
            }
        } label: {
            Text("분석하기")
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
    @State private var recordedDiarys: [String:[Double:String]] = [:]   // [현재날짜:[감정지수:일기내용]]
    
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
        recordedDiarys[currentDate] = [contentsManager.sentimentValue:inputText]
        if let data = try? JSONEncoder().encode(recordedDiarys) {
            recordedDiarysAppStorage = data
        }
    }
    
    private func decodeDiary() {
        if let data = try? JSONDecoder().decode([String:[Double:String]].self, from: recordedDiarysAppStorage) {
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
            recordedDiarys = recordedDiarys.filter { (key, _) -> Bool in
                if let date = dateFormatter.date(from: key) {
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
            Text("☑️").font(.system(size: 100))
            Text("오늘은 이미 작성했어요. 내일 다시 작성 해주세요.")
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
    
    private func getCurrentLocation() {
        if let latitude = locationManager.locationManager.location?.coordinate.latitude,
           let longitude = locationManager.locationManager.location?.coordinate.longitude {
            locationManager.latitude = latitude
            locationManager.longitude = longitude
        }
    }
}

#Preview {
    HaruDiary(serverState: .constant(.bad))
}
