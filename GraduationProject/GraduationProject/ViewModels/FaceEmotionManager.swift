//
//  FaceEmotionManager.swift
//  GraduationProject
//
//  Created by a mystic on 11/20/23.
//

import SwiftUI

class FaceEmotionManager: ObservableObject {
    static let shared = FaceEmotionManager()

    @Published private(set) var faceEmotions: [String:Int] = [
        "😁" : 0,
        "🙂" : 0,
        "😡" : 0,
        "😠" : 0,
        "😮" : 0,
        "🙁" : 0
    ]
    @Published private(set) var isAnalyzing = false
    @Published var currentEmotion = "😐"
    
    var faceEmotionValue: Double {
        var sumOfEmotionValues = 0
        faceEmotions.values.forEach { value in
            sumOfEmotionValues += value
        }
        var emotionValue = 0
        for emotion in faceEmotions.keys {
            if ["😡", "😠", "😮", "🙁"].contains(emotion) {
                emotionValue -= faceEmotions[emotion]!
            } else if ["😁", "🙂"].contains(emotion) {
                emotionValue += faceEmotions[emotion]!
            }
        }
        return Double(emotionValue) / Double(sumOfEmotionValues)
    }
    
    var currentColor: Color {
        switch currentEmotion {
        case "😁", "🙂": 
            return .orange
        case "😡", "😠":
            return .red
        case "😮":
            return .blue
        case "🙁":
            return .cyan
        default:
            return .mint
        }
    }
    
    func setEmotion(_ emotion: String) {
        if isAnalyzing {
            currentEmotion = emotion
            if faceEmotions.keys.contains(emotion) {
                faceEmotions[emotion]! += 1
            }
        }
    }
    
    func startAnalyzing() {
        isAnalyzing = true
    }
    
    func stopAnalyzing() {
        isAnalyzing = false
    }
    
    func reset() {
        faceEmotions = [
            "😁" : 0,
            "🙂" : 0,
            "😡" : 0,
            "😠" : 0,
            "😮" : 0,
            "🙁" : 0
        ]
        isAnalyzing = false
        currentEmotion = "😐"
    }
}
