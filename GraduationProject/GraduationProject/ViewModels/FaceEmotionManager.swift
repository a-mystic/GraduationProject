//
//  FaceEmotionManager.swift
//  GraduationProject
//
//  Created by a mystic on 11/20/23.
//

import SwiftUI

class FaceEmotionManager: ObservableObject {
    @Published private(set) var faceEmotions: [String:Int] = [
        "😁" : 0,
        "🙂" : 0,
        "😡" : 0,
        "😠" : 0,
        "😛" : 0,
        "😮" : 0
    ]
    @Published private(set) var isAnalyzing = false
    @Published var currentEmotion = "😐"
    
    var currentColor: Color {
        switch currentEmotion {
        case "😁", "🙂": 
            return .orange
        case "😡", "😠":
            return .red
        case "😛", "😮":
            return .blue
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
}
