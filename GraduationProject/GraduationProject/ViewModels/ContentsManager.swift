//
//  ContentsManager.swift
//  GraduationProject
//
//  Created by a mystic on 3/14/24.
//

import Foundation

class ContentsManager: ObservableObject {
    @Published private(set) var recommendCategory = ""
    @Published private(set) var recommendContent = ""
    @Published private(set) var sentimentValue: Double = 0.7
    @Published private(set) var needHate = false
    
    func setRecommendContent(to content: String) {
        recommendContent = content
    }
    
    func setRecommendCategory(to category: String) {
        recommendCategory = category
    }
        
    func setSentimentValue(to value: Double) {
        sentimentValue = value
    }
    
    func setNeedHate() {
        needHate = true
    }
}
