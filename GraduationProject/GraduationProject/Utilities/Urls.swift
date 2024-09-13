//
//  Urls.swift
//  GraduationProject
//
//  Created by a mystic on 4/17/24.
//

import Foundation

struct ServerUrls {
    static let base = "https://4c71-175-205-103-204.ngrok-free.app"
    static let sentimentValue = "\(base)/sentimentValue"
    static let chat = "\(base)/chat"
    static let check = "\(base)/check"
}

struct ContentUrls {
    // 개별요소들에 대해서 링크를 걸어야 할것 같습니다 예를들어서 "컴퓨터": ["책1링크", "책2링크"]로 만들고 random하게 선택하는 방식으로
    static let musicUrls = [
        "클래식" : ["https://www.youtube.com/watch?v=J8YjBl4cuuY&pp=ygUQ7YG0656Y7IudIOydjOyVhQ%3D%3D"],
        "팝송" : ["https://www.youtube.com/watch?v=2G_9XIjIUJs&pp=ygUG7Yyd7Iah"],
        "발라드" : ["https://www.youtube.com/watch?v=qIcriAGSQhw&pp=ygUJ67Cc652865Oc"],
        "케이팝" : ["https://www.youtube.com/watch?v=mJAFXn4-q04&pp=ygUJ7LyA7J207Yyd"]
    ]
    
    static let movieUrls = [
        "코미디" : ["https://www.imdb.com/title/tt21692408/?ref_=sr_t_11"],
        "모험" : ["https://www.imdb.com/title/tt13186482/?ref_=sr_t_4"],
        "다큐멘터리" : ["https://www.imdb.com/title/tt31316096/?ref_=sr_t_1"],
        "과학" : ["https://www.imdb.com/title/tt15239678/?ref_=sr_t_1"],
        "역사" : ["https://www.imdb.com/title/tt15398776/?ref_=sr_t_2"]
    ]
    
    static let youtubeUrls = [
        "코미디" : ["https://www.youtube.com/watch?v=n9yXBQIzO2w&pp=ygUS7L2U66-465SU7Jyg7Yqc67iM"],
        "모험" : ["https://www.youtube.com/watch?v=O4SLJAkDXvA&pp=ygUJZWJz7Jes7ZaJ"],
        "다큐멘터리" : ["https://www.youtube.com/watch?v=7C0OtmCTwto&pp=ygUZ64uk7YGQ66mY7YSw66asIOycoO2KnOu4jA%3D%3D"],
        "과학" : ["https://www.youtube.com/watch?v=m3jb8Z8u1Xk&pp=ygUP6rO87ZWZ7Jyg7Yqc67iM"],
        "역사" : ["https://www.youtube.com/watch?v=CaG7fR0q-4A&pp=ygUP7Jet7IKs7Jyg7Yqc67iM"]
    ]
    
    static let bookUrls = [
        "컴퓨터" : ["https://www.yes24.com/Product/Goods/72150192"],
        "추리소설" : ["https://www.yes24.com/Product/Goods/15292219"],
        "인문학" : ["https://www.yes24.com/Product/Goods/122120495"],
        "심리학" : ["https://www.yes24.com/Product/Goods/118579613"],
        "과학" : ["https://www.yes24.com/Product/Goods/2312211"],
        "공학" : ["https://www.yes24.com/Product/Goods/117008111"],
    ]
}
