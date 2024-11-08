from fastapi import FastAPI
import pymongo.errors
import requests
import json
import pymongo
import google.generativeai as genai

# 실행코드
# uvicorn main:app --reload

# naver sentiment api 초기화
app = FastAPI()
naverClient_id = "fill"
naverClient_secret = "fill"
naverApiUrl="https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"
headers = {
    "X-NCP-APIGW-API-KEY-ID": naverClient_id,
    "X-NCP-APIGW-API-KEY": naverClient_secret,
    "Content-Type": "application/json"
}

# google gemini를 사용하였습니다.
# defaultHistory는 일단 심리상담을 해주도록 기본 설정을 해놓은 변수입니다.
geminiApiKey = "fill"
genai.configure(api_key= geminiApiKey)
model = genai.GenerativeModel("gemini-1.5-flash")
defaultHistory = [
    {"parts": ["앞으로 답변할때 사용자가 일부로 요구하지 않는다면 9문장 이내로 답변해주세요"], "role": "user"},
    {"parts": ["확실히, 저는 사용자가 특별히 요청하지 않는 이상 앞으로 답변을 9문장 이내로 제한하겠습니다."], "role": "model"},
    {"parts": ["또한 답변할때는 최대한 사람이 답변하는것처럼 자연스럽게 해주세요"], "role": "user"},
    {"parts": ["언제나 자연스럽게 응답하려고 최선을 다하겠습니다. 저는 사람이 아니지만, 인간 언어와 대화를 이해하고 생성하도록 훈련되었습니다."], "role": "model"},
    {"parts": ["마지막으로 앞으로는 이전에 요청한 사항들을 적용해서 심리상담사의 입장에서 질문들에 답변해주세요"], "role": "user"},
    {"parts": ["확실합니다. 이전에 요청하신 사항을 적용하여 심리상담사의 입장에서 9문장 이내로 자연스럽게 답변하겠습니다."], "role": "model"}
    ]

# mongodb 데이터베이스와 연결하는 코드입니다 최근의 20개의 대화를 불러오도록 쿼리를 작성하였습니다
mongodbClient = pymongo.MongoClient('localhost', 27017)
collection = mongodbClient["Chat"]["ChatHistory"]
collectionSize = collection.count_documents({})
startIndex = max(0, collectionSize - 20)
pipeline = [
    {"$project": {"_id": 0, "parts": 1, "role": 1}},
    {"$skip": startIndex},
    {"$limit": 20}
]

# 호출방식: [localhost주소]/sentimentValue?inputText="text"
@app.get("/sentimentValue")
async def calcSentimentValue(inputText: str):
    # Test 
    return {"sentimentValue" : 0.7500819 }
    data = {"content" : inputText}
    response = requests.post(naverApiUrl, data=json.dumps(data), headers=headers).json()
    maxConfidence = max(response["document"]["confidence"], key=response["document"]["confidence"].get)
    # 분석한 감정에 나타난 수치를 0에서1 값으로 표현하기위해 100으로 나누는 코드입니다.
    normalizedConfidence = response["document"]["confidence"][maxConfidence] / 100
    # 분석한 감정이 부정적이라면 감정수치에 마이너스를 곱해서 감정수치를 -1에서1 값으로 표현합니다.
    if str(response["document"]["sentiment"]) == "negative":
        normalizedConfidence *= -1 
    return {"sentimentValue" : normalizedConfidence}

def insertMessageToMongodb(message: str, role: str):
    collection.insert_one({"parts": message, "role": role})

# 처음에 세팅한 defaulthistory에 먼저 설정된 내용과 데이터 베이스에 저장된 최근 20개의 대화 목록을 불러와서 모델의 초기정보를 세팅합니다.
# 그다음 iOS에서 유저가 입력한 채팅내용을 전달받고 defaulthistory로 세팅된 google gemini api에 전달해주고 응답을 받아서 데이터베이스에 저장한다음 리턴해주는 방식입니다.
@app.get("/chat")
async def chat(message: str):
    # init history
    history = defaultHistory
    datas = list(collection.aggregate(pipeline= pipeline))
    if datas:
        for data in datas:
            history.append({"parts": data["parts"], "role": data["role"]})

    chat = model.start_chat(history= history)
    insertMessageToMongodb(message= message, role= "user")
    response = chat.send_message(message)
    insertMessageToMongodb(message= response.text, role= "model")
    return {"message": response.text}

@app.get("/check")
async def check():
    try:
        mongodbClient.admin.command("ping")
        return True
    except pymongo.errors.ConnectionFailure:
        return False