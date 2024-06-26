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
    @State private var showDescription = false
    @State private var showRecommendedContent = false
    @State private var loginIsNeed = false
//    @AppStorage("userInputIsNeed") private var userInfoIsNeed = true
    @State private var userInfoIsNeed = true
    
    private var locationManager = LocationManager.manager
    
    var body: some View {
        NavigationStack {
            ZStack {
                background
                VStack(spacing: 30) {
                    inputField
                    analyze
                }
                ProgressView()
                    .scaleEffect(2)
                    .opacity(isFetching ? 1 : 0)
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
    
    private var background: some View {
        Color.gray
            .opacity(0.1)
            .ignoresSafeArea(edges: .bottom)
            .onTapGesture {
                isFocused = false
            }
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
    
    @EnvironmentObject var contentsManager: ContentsManager

    private func analyzeHaru() async {
        isFetching = true
        let url = ServerUrls.sentimentValue + "/sentimentValue?inputText=\(inputText)"
        guard let encodingUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: encodingUrl) else { return }
        do {
//            let (data, _) = try await URLSession.shared.data(from: url)
//            let responseData = try JSONDecoder().decode(SentimentData.self, from: data)
//            contentsManager.setSentimentValue(to: responseData.sentimentValue)
            // test
            contentsManager.setSentimentValue(to: 0.51)
            isFetching = false
            showAskView = true
        } catch {
            print(error)
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
    HaruDiary()
}
