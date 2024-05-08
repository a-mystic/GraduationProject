//
//  UserInfo.swift
//  GraduationProject
//
//  Created by a mystic on 4/8/24.
//

import SwiftUI

struct UserInfo: View {
    @Environment(\.dismiss) var dismiss
    
    @Binding var isShow: Bool
    
    var body: some View {
        NavigationStack {
            Form {
                Section("기분이 좋을때 하는 행동들을 선택해주세요") {
                    positiveInput
                }
                Section("기분이 안좋을때 하는 행동들을 선택해주세요") {
                    negativeInput
                }
                if selectedPositiveCategories.count > 0 {
                    Section("기분이 좋을때 하는 행동들을 더 자세하게 선택해주세요") {
                        positiveMore
                    }
                }
                if selectedNegativeCategories.count > 0 {
                    Section("기분이 안좋을때 하는 행동들을 더 자세하게 선택해주세요") {
                        negativeMore
                    }
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    save
                }
            }
        }
    }
    
    @State private var positiveCategories = ["영상시청", "음악", "책", "야외활동"]
    @State private var selectedPositiveCategories: [String] = []
    @AppStorage("selectedPositiveCategoriesAppStorage") var selectedPositiveCategoriesAppStorage = Data()
    
    private var positiveInput: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(positiveCategories, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(selectedPositiveCategories.contains(item) ? .black : .gray)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text(item)
                                .foregroundStyle(selectedPositiveCategories.contains(item) ? .black : .gray)
                                .font(.body)
                        }
                        .onTapGesture {
                            if selectedPositiveCategories.contains(item) {
                                if let index = selectedPositiveCategories.firstIndex(of: item) {
                                    selectedPositiveCategories.remove(at: index)
                                }
                            } else {
                                selectedPositiveCategories.append(item)
                            }
                        }
                }
            }
            .padding(.vertical)
        }
    }
    
    @State private var negativeCategories = ["영상시청", "음악", "책", "야외활동"]
    @State private var selectedNegativeCategories: [String] = []
    @AppStorage("selectedNegativeCategoriesAppStorage") var selectedNegativeCategoriesAppStorage = Data()
    
    private var negativeInput: some View {
        ScrollView(.horizontal) {
            HStack(spacing: 10) {
                ForEach(negativeCategories, id: \.self) { item in
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(lineWidth: 1)
                        .foregroundStyle(selectedNegativeCategories.contains(item) ? .black : .gray)
                        .frame(width: 100, height: 50)
                        .overlay {
                            Text(item)
                                .foregroundStyle(selectedNegativeCategories.contains(item) ? .black : .gray)
                                .font(.body)
                        }
                        .onTapGesture {
                            if selectedNegativeCategories.contains(item) {
                                if let index = selectedNegativeCategories.firstIndex(of: item) {
                                    selectedNegativeCategories.remove(at: index)
                                }
                            } else {
                                selectedNegativeCategories.append(item)
                            }
                        }
                }
            }
            .padding(.vertical)
        }
    }
    
    private let CategoryDetails: [String:[String]] = [
        "영상시청" : ["코미디", "모험", "다큐멘터리", "과학", "역사"],    // 수정필요
        "음악" : ["발라드", "케이팝", "팝송", "클래식"],
        "책" : ["추리소설", "인문학", "심리학", "과학", "공학", "컴퓨터"],
        "야외활동": ["산책", "쇼핑", "운동"]
    ]
    
    @State private var selectedPositiveDetails: [String:[String]] = [
        "영상시청" : [],
        "음악" : [],
        "책" : [],
        "야외활동": []
    ]
    
    @AppStorage("selectedPositiveDetailsAppStorage") var selectedPositiveDetailsAppStorage = Data()
    
    private let gridItemColumns = [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]
    
    private var positiveMore: some View {
        VStack {
            ForEach(selectedPositiveCategories, id: \.self) { category in
                if let details = CategoryDetails[category] {
                    Section("\(category) 추가정보") {
                        LazyVGrid(columns: gridItemColumns, spacing: 10) {
                            ForEach(details, id: \.self) { detail in
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(selectedPositiveDetails[category]!.contains(detail) ? .black : .gray)
                                    .frame(width: 100, height: 50)
                                    .overlay {
                                        Text(detail)
                                            .foregroundStyle(selectedPositiveDetails[category]!.contains(detail) ? .black : .gray)
                                            .font(.body)
                                    }
                                    .onTapGesture {
                                        if var details = selectedPositiveDetails[category] {
                                            if details.contains(detail) {
                                                if let index = details.firstIndex(of: detail) {
                                                    details.remove(at: index)
                                                    selectedPositiveDetails[category] = details
                                                }
                                            } else {
                                                details.append(detail)
                                                selectedPositiveDetails[category] = details
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                Divider()
            }
        }
    }
    
    @State private var selectedNegativeDetails: [String:[String]] = [
        "영상시청" : [],
        "음악" : [],
        "책" : [],
        "야외활동": []
    ]
    
    @AppStorage("selectedNegativeDetailsAppStorage") var selectedNegativeDetailsAppStorage = Data()
    
    private var negativeMore: some View {
        VStack {
            ForEach(selectedNegativeCategories, id: \.self) { category in
                if let details = CategoryDetails[category] {
                    Section("\(category) 추가정보") {
                        LazyVGrid(columns: gridItemColumns, spacing: 10) {
                            ForEach(details, id: \.self) { detail in
                                RoundedRectangle(cornerRadius: 14)
                                    .stroke(lineWidth: 1)
                                    .foregroundStyle(selectedNegativeDetails[category]!.contains(detail) ? .black : .gray)
                                    .frame(width: 100, height: 50)
                                    .overlay {
                                        Text(detail)
                                            .foregroundStyle(selectedNegativeDetails[category]!.contains(detail) ? .black : .gray)
                                            .font(.body)
                                    }
                                    .onTapGesture {
                                        if var details = selectedNegativeDetails[category] {
                                            if details.contains(detail) {
                                                if let index = details.firstIndex(of: detail) {
                                                    details.remove(at: index)
                                                    selectedNegativeDetails[category] = details
                                                }
                                            } else {
                                                details.append(detail)
                                                selectedNegativeDetails[category] = details
                                            }
                                        }
                                    }
                            }
                        }
                    }
                }
                Divider()
            }
        }
    }
    
    private var save: some View {
        Button("Save") {
            if let positiveData = try? JSONEncoder().encode(selectedPositiveCategories),
               let negativeData = try? JSONEncoder().encode(selectedNegativeCategories),
               let positiveDetails = try? JSONEncoder().encode(selectedPositiveDetails),
               let negativeDetails = try? JSONEncoder().encode(selectedNegativeDetails) {
                selectedPositiveCategoriesAppStorage = positiveData
                selectedNegativeCategoriesAppStorage = negativeData
                selectedPositiveDetailsAppStorage = positiveDetails
                selectedNegativeDetailsAppStorage = negativeDetails
            }
            isShow = false
            dismiss()
        }
    }
}

#Preview {
    UserInfo(isShow: .constant(true))
}
