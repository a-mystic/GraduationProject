//
//  Urls.swift
//  GraduationProject
//
//  Created by a mystic on 4/17/24.
//

import Foundation

struct ServerUrls {
    static let base = "https://9d91-2001-2d8-6201-efc4-d480-a3c0-f22e-4b81.ngrok-free.app"
    static let sentimentValue = "\(base)/sentimentValue"
    static let chat = "\(base)/chat"
    static let check = "\(base)/check"
}

struct ContentUrls {
    static let musicUrls = [
        "클래식" : [
            "https://www.youtube.com/watch?v=XO6Zcrnopgw&pp=ygUNY2xhc3NpYyBtdXNpYw%3D%3D",
            "https://www.youtube.com/watch?v=7OYkWSW7u4k&pp=ygUNY2xhc3NpYyBtdXNpYw%3D%3D",
            "https://www.youtube.com/watch?v=mGQLXRTl3Z0&pp=ygUNY2xhc3NpYyBtdXNpYw%3D%3D",
            "https://www.youtube.com/watch?v=rUuusqy50yk&pp=ygUNY2xhc3NpYyBtdXNpYw%3D%3D"
                ],
        "팝송" : [
            "https://youtu.be/nfs8NYg7yQM?si=Nx_2UaCgWs5Za24H",
            "https://youtu.be/JGwWNGJdvx8?si=b_GGZe37YatKv_9P",
            "https://youtu.be/09R8_2nJtjg?si=Q-Bm6R6BNeGtI-hU",
            "https://youtu.be/kffacxfA7G4?si=uS92vdFubk-fqB3c"
            
        ],
        "발라드" : [
            "https://www.youtube.com/watch?v=yT8SYItNvKg&pp=ygULYmFsbGFkIHNvbmc%3D",
            "https://www.youtube.com/watch?v=OcDzwNijxZ4&pp=ygULYmFsbGFkIHNvbmc%3D",
            "https://www.youtube.com/watch?v=E6rgygrjNHg&pp=ygULYmFsbGFkIHNvbmc%3D",
            "https://www.youtube.com/watch?v=qUb6_n1Z7vI&pp=ygULYmFsbGFkIHNvbmc%3D"
        ],
        "케이팝" : [
            "https://youtu.be/jWQx2f-CErU?si=OR2p_grch6QPFCF4",
            "https://youtu.be/m6pTbEz4w3o?si=_TlFPpRtaoBu9QbV",
            "https://youtu.be/eMk_0svqsnI?si=3vZtMcBQ0yYU7eFn",
            "https://youtu.be/yjxLMzeV76Q?si=MYbTVUBlT9e-uYEq"
        ]
    ]
    
    static let movieUrls = [
        "코미디" : [
            "https://www.imdb.com/title/tt5822536/?ref_=int_cs_tt_i_2",
            "https://www.imdb.com/title/tt6263850/?ref_=sr_t_8",
            "https://www.imdb.com/title/tt9860566/?ref_=sr_t_3",
            "https://www.imdb.com/title/tt22022452/?ref_=sr_t_13"
        ],
        "모험" : [
            "https://www.imdb.com/title/tt16366836/?ref_=sr_t_1",
            "https://www.imdb.com/title/tt9218128/?ref_=sr_t_2",
            "https://www.imdb.com/title/tt0172495/?ref_=sr_t_9",
            "https://www.imdb.com/title/tt15239678/?ref_=sr_t_13"
        ],
        "다큐멘터리" : [
            "https://www.imdb.com/title/tt27902121/?ref_=sr_t_6",
            "https://www.imdb.com/title/tt14821376/?ref_=sr_t_13",
            "https://www.imdb.com/title/tt33355888/?ref_=sr_t_16",
            "https://www.imdb.com/title/tt33600145/?ref_=sr_t_18"
        ],
        "과학" : [
            "https://www.imdb.com/title/tt18412256/?ref_=sr_t_3",
            "https://www.imdb.com/title/tt29623480/?ref_=sr_t_2",
            "https://www.imdb.com/title/tt8864596/?ref_=sr_t_5",
            "https://www.imdb.com/title/tt0816692/?ref_=sr_t_11"
        ],
        "역사" : [
            "https://www.imdb.com/title/tt15398776/?ref_=sr_t_4",
            "https://www.imdb.com/title/tt27987046/?ref_=sr_t_7",
            "https://www.imdb.com/title/tt8503618/?ref_=sr_t_37",
            "https://www.imdb.com/title/tt1655389/?ref_=sr_t_50"
        ]
    ]
    
    static let youtubeUrls = [
        "코미디" : [
            "https://www.youtube.com/@THETHREESTOOGESCOMEDYCHANNEL",
            "https://www.youtube.com/@CorysComedyChannel",
            "https://www.youtube.com/@ComedyCentral"
        ],
        "모험" : [
            "https://www.youtube.com/@A1ADVENTURE",
            "https://www.youtube.com/@OutdoorBoys",
            "https://www.youtube.com/@BacktoBasics"
               ],
        "다큐멘터리" : [
            "https://www.youtube.com/@FreeDocumentary",
            "https://www.youtube.com/@documentary-channel",
            "https://www.youtube.com/@NatGeo"
        ],
        "과학" : [
            "https://www.youtube.com/@learningsciencechannel1894",
            "https://www.youtube.com/@Professor-Bart-Kay-Nutrition",
            "https://www.youtube.com/@mr.scottssciencechannel9060"
               ],
        "역사" : [
            "https://www.youtube.com/@HISTORY",
            "https://www.youtube.com/@odyssey",
            "https://www.youtube.com/@HistoryoftheUniverse"
               ]
    ]
    
    static let bookUrls = [
        "컴퓨터" : [
            "https://www.yes24.com/Product/Goods/72150192",
            "https://www.yes24.com/Product/Goods/122318967",
            "https://www.yes24.com/Product/Goods/44264704"
        ],
        "추리소설" : [
            "https://www.yes24.com/Product/Goods/128917300",
            "https://www.yes24.com/Product/Goods/45353675",
            "https://www.yes24.com/Product/Goods/126111057"
        ],
        "인문학" : [
            "https://www.yes24.com/Product/Goods/125557465",
            "https://www.yes24.com/Product/Goods/134602629",
            "https://www.yes24.com/Product/Goods/122120495"
        ],
        "심리학" : [
            "https://www.yes24.com/Product/Goods/118579613",
            "https://www.yes24.com/Product/Goods/122428190",
            "https://www.yes24.com/Product/Goods/116599423"
                ],
        "과학" : [
            "https://www.yes24.com/Product/Goods/65067259",
            "https://www.yes24.com/Product/Goods/120230798",
            "https://www.yes24.com/Product/Goods/17622312"
        ],
        "공학" : [
            "https://www.yes24.com/Product/Goods/117008111",
            "https://www.yes24.com/Product/Goods/37011241",
            "https://www.yes24.com/Product/Goods/128197782"
        ],
    ]
}
