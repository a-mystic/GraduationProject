//
//  ContentView.swift
//  sentimentCall
//
//  Created by a mystic on 2023/06/21.
//

import SwiftUI
import Alamofire

struct ContentView: View {
    var body: some View {
        Button("callAPI") {
            callAPI()
        }
    }
}

private func callAPI() {
    let url = "https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"
    let clientID = "clientID"
    let clientSecretId = "clientSecret"
    let headers: HTTPHeaders = [
        "X-NCP-APIGW-API-KEY-ID" : clientID,
        "X-NCP-APIGW-API-KEY" : clientSecretId,
        "Content-Type" : "application/json"
    ]
    let content = "햇살이 부드럽게 내리쬐며, 미소가 얼굴에 만개하고 마음은 무거운 짐을 벗어던지며 자유롭게 날개를 펴고 휘날리네. 향기로운 꽃들이 나의 미래를 상상하게 하며, 따스한 손길에 안기고 싶어져 삶이 그림 같이 아름답고 소중함을 가득 채운다. 세상은 마치 새로운 시작으로, 가슴은 행복으로 가득차고 눈물은 어제의 아픔으로 씻어나가며 희망의 꽃들이 피어난다. 영원히 지속되는 행복의 여정에서, 사랑과 감사가 나를 감싸 안아주어 깨어난 이 순간이 신비로운 일상의 소중한 보물이 되어준다.."
    let body: Parameters = ["content" : content]
    
    let dataRequest = AF.request(url, method: .post, parameters: body, encoding: JSONEncoding.default, headers: headers)
    dataRequest.responseData { response in
        switch response.result {
        case .success(let data):
            let decoder = JSONDecoder()
            if let decodeData = try? decoder.decode(Response.self, from: data) {
                print(decodeData)
            }
        case .failure(let error):
            print(error)
        }
    }
}

struct Sentence: Codable {
    let content: String
    let offset: Int
    let length: Int
    let sentiment: String
    let confidence: Confidence
    let highlights: [Highlight]
}

struct Confidence: Codable {
    let negative: Double
    let positive: Double
    let neutral: Double
}

struct Highlight: Codable {
    let offset: Int
    let length: Int
}

struct Document: Codable {
    let sentiment: String
    let confidence: Confidence
}

struct Response: Codable {
    let document: Document
    let sentences: [Sentence]
}




struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
