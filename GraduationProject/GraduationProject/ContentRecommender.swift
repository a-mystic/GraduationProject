//
//  ContentRecommender.swift
//  GraduationProject
//
//  Created by a mystic on 10/27/23.
//

import SwiftUI

struct ContentRecommender: View {
    @EnvironmentObject var contentsManager: ContentsManager
    
    var body: some View {
        GeometryReader { geometry in
            ScrollView {
                VStack(spacing: 20) {
                    LottieView(jsonName: "bear", loopMode: .repeat(3))
                        .frame(width: 170, height: 170)
                    finalEmotion
                    recommendCard
                        .frame(width: geometry.size.width * 0.95, height: geometry.size.height * 0.4)
                    like(in: geometry)
                    if contentsManager.needHate {
                        hate(in: geometry)
                    }
                    Spacer()
                }
                .frame(width: geometry.size.width)
            }
        }
    }
    
    private var analyzedSentiment: String {
        if contentsManager.sentimentValue <= 1 && contentsManager.sentimentValue > 0.5 {
            return "😄"
        } else if contentsManager.sentimentValue <= 0.5 && contentsManager.sentimentValue > 0 {
            return "😀"
        } else if contentsManager.sentimentValue == 0 {
            return "😐"
        } else if contentsManager.sentimentValue >= -0.5 && contentsManager.sentimentValue < 0 {
            return "🙁"
        } else if contentsManager.sentimentValue >= -1 && contentsManager.sentimentValue < -0.5 {
            return "☹️"
        }
        return "😐"
    }
    
    private var finalEmotion: some View {
        VStack {
            HStack {
                Text("최종적으로 분석된 감정: ")
                    .bold()
                Text(analyzedSentiment)
                    .font(.largeTitle)
            }
            .padding(.horizontal)
            .font(.title2)
        }
        .padding()
        .background {
            RoundedRectangle(cornerRadius: 14)
                .foregroundStyle(.blue.opacity(0.2))
        }
        .bold()
        .font(.footnote)
        .foregroundStyle(.black)
    }
    
    
    private var recommendCard: some View {
        ZStack(alignment: .bottom) {
            Image("recommenderBackground")
                .resizable()
                .clipShape(RoundedRectangle(cornerRadius: 14))
            Group {
                if contentsManager.recommendContent != "" {
                    VStack {
                        Text(contentsManager.recommendCategory)
                            .font(.body)
                            .padding(10)
                            .background(.gray.opacity(0.5), in: RoundedRectangle(cornerRadius: 12))
                        Text("\(contentsManager.recommendContent) 추천드려요")
                    }
                } else {
                    Text("\(contentsManager.recommendCategory) 추천드려요")
                }
            }
            .bold()
            .font(.title)
            .foregroundStyle(.white.opacity(0.9))
            .padding()
            .padding(.horizontal)
            .background(.black.opacity(0.6))
            .clipShape(RoundedRectangle(cornerRadius: 14))
        }
        .overlay {
            LottieView(jsonName: "congratulations", loopMode: .playOnce)
        }
        .sheet(isPresented: $showWebsite) {
            SafariView(url: URL(string: websiteUrl)!)
        }
        .sheet(isPresented: $showMap) {
            MapView(place: place)
        }
    }
    
    @State private var showWebsite = false
    @State private var showMap = false
    
    private var place: String {
        switch contentsManager.recommendContent {
        case "운동":
            return "체육관"
        case "산책":
            return "운동장"
        case "쇼핑":
            return "쇼핑몰"
        default:
            return "운동장"
        }
    }
    
    private var websiteUrl: String {
        switch contentsManager.recommendCategory {
        case "음악":
            if let url = ContentUrls.musicUrls[contentsManager.recommendContent]?.randomElement() {
                return url
            }
            return "https://open.spotify.com"
        case "유튜브":
            if let url = ContentUrls.youtubeUrls[contentsManager.recommendContent]?.randomElement() {
                return url
            }
            return "https://www.youtube.com/"
        case "책":
            if let url = ContentUrls.bookUrls[contentsManager.recommendContent]?.randomElement() {
                return url
            }
            return "https://www.yes24.com/main/default.aspx"
        case "영화":
            if let url = ContentUrls.movieUrls[contentsManager.recommendContent]?.randomElement() {
                return url
            }
            return "https://www.imdb.com/"
        default:
            return ""
        }
    }
    
    private var isWebsite: Bool {
        if ["음악", "유튜브", "영화", "책"].contains(contentsManager.recommendCategory) {
            return true
        } else {
            return false
        }
    }
    
    private func like(in geometry: GeometryProxy) -> some View {
        Button {
            if isWebsite {
                showWebsite = true
            } else {
                showMap = true
            }
        } label: {
            Text("마음에 들어요")
                .padding(.vertical, 9)
                .frame(maxWidth: geometry.size.width * 0.8)
        }
        .padding(.vertical, 9)
        .foregroundStyle(.white)
        .background(.blue.opacity(0.7), in: RoundedRectangle(cornerRadius: 12))
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
    
    private let contentsCategories: [String:[String]] = [
        "영상시청" : ["영화", "유튜브"],
        "음악" : ["음악"],
        "책" : ["책"],
        "야외활동" : ["야외활동"]
    ]
    
    private func hate(in geometry: GeometryProxy) -> some View {
        Button {
            if contentsManager.sentimentValue > 0 {
                if let selectedCategory = selectedPositiveCategories.randomElement(),
                   let recommendCategory = contentsCategories[selectedCategory]?.randomElement(),
                   let content = selectedPositiveDetails[selectedCategory]?.randomElement() {
                    contentsManager.setRecommendCategory(to: recommendCategory)
                    contentsManager.setRecommendContent(to: content)
                }
            } else {
                if let selectedCategory = selectedNegativeCategories.randomElement(),
                   let recommendCategory = contentsCategories[selectedCategory]?.randomElement(),
                   let content = selectedNegativeDetails[selectedCategory]?.randomElement() {
                    contentsManager.setRecommendCategory(to: recommendCategory)
                    contentsManager.setRecommendContent(to: content)
                }
            }
            contentsManager.setNeedHate(to: false)
        } label: {
            Text("마음에 안들어요")
                .padding(.vertical, 9)
                .frame(maxWidth: geometry.size.width * 0.8)
        }
        .padding(.vertical, 9)
        .foregroundStyle(.white)
        .background(.red.opacity(0.7), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    let contentsManager = ContentsManager()
    contentsManager.setRecommendCategory(to: "음악")
    contentsManager.setRecommendContent(to: "")
    return ContentRecommender()
        .environmentObject(contentsManager)
}
