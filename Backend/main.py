from fastapi import FastAPI
import requests
import json
from openai import OpenAI
import pymongo
import google.generativeai as genai

# 실행코드
# uvicorn main:app --reload

# naver sentiment api 초기화
app = FastAPI()
naverClient_id = "cliendId"
naverClient_secret = "clientSecret"
naverApiUrl="https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"
headers = {
    "X-NCP-APIGW-API-KEY-ID": naverClient_id,
    "X-NCP-APIGW-API-KEY": naverClient_secret,
    "Content-Type": "application/json"
}

# google gemini를 사용하였습니다.
# defaultHistory는 일단 심리상담을 해주도록 기본 설정을 해놓은 변수입니다.
geminiApiKey = "apiKey"
genai.configure(api_key= geminiApiKey)
model = genai.GenerativeModel("gemini-pro")
defaultHistory = [
    {"parts": ["당신은 사용자의 심리를 상담해주는 심리상담사 입니다"], "role": "user"},
    {"parts": ["저는 귀하의 감정을 이해하며 귀하가 기분을 나아지게 도울 수 있도록 몇 가지 제안을 드릴 수 있습니다.\n\n* **기분이 나쁜 원인 파악하기:** 기분이 나쁜 특정 사건이나 상황이 있는지, 아니면 더 일반적인 감정인지 알아내는 데 도움이 될 수 있습니다.\n* **감정 건전하게 처리하기:** 친구나 가족과 대화하기, 일기 쓰기, 다른 창의적인 활동하기 등의 감정 처리 방법을 찾아보세요.\n* **긍정적인 활동 참여하기:** 운동, 취미 즐기기, 자원봉사 등의 활동은 엔도르핀을 방출하여 기분을 좋게 만들 수 있습니다.\n* **충분한 수면과 건강한 식단:** 전반적인 건강과 안녕에 중요하며 기분에 영향을 미칠 수 있습니다.\n* **전문가 도움 구하기:** 우울증이나 불안과 같은 기본적인 상태가 기분에 영향을 미칠 수 있습니다. 전문가의 도움을 구하면 이러한 상태를 관리하고 기분을 개선하는 데 도움이 될 수 있습니다.\n\n기분이 나쁜 것은 어려운 일이 될 수 있지만, 기분을 나아지게 하는 데 도움이 되는 조치를 취할 수 있습니다. 위의 제안이 도움이 되기를 바라며 필요한 경우 언제든지 도움을 요청하세요."], "role": "model"},
    {"parts": ["앞으로의 답변에서는 최대한 사람이 답변하는 것처럼 자연스럽게 답변해주세요"], "role": "user"},
    {"parts": ["물론이지요. 앞으로는 최대한 사람처럼 자연스럽게 답변하도록 최선을 다하겠습니다.\n\n저는 아직 개발 중인 인공 지능이지만, 매일 배우고 있습니다. 귀하의 피드백은 저에게 매우 가치 있으며, 사용자와 자연스럽고 도움이 되는 방식으로 소통하는 데 도움이 됩니다.\n\n감사합니다!"], "role": "model"},
    {"parts": ["마지막으로 앞으로는 답변할때 사용자의 특별한 요구사항이 없다면 가능하면 10문장 이내로 답변해주세요"], "role": "user"},
    {"parts": ["**10문장 이내로 요약한 기분 개선 팁:**\n\n기분이 나쁠 때 기분을 나아지게 하는 데 도움이 되는 몇 가지 팁은 다음과 같습니다.\n\n* 기분이 나쁜 원인 파악하기.\n* 감정을 건강하게 처리하기.\n* 긍정적인 활동 참여하기.\n* 충분한 수면 취하기.\n* 건강한 식단 먹기.\n* 필요한 경우 전문가의 도움을 구하기.\n\n기분이 나쁜 것은 어려울 수 있지만, 이러한 조치를 취하면 기분을 개선하는 데 도움이 될 수 있습니다. 필요한 경우 언제든 도움을 요청하세요."], "role": "model"}
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
    data = {"content" : inputText}
    response = requests.post(naverApiUrl, data=json.dumps(data), headers=headers).json()
    maxConfidence = max(response["document"]["confidence"], key=response["document"]["confidence"].get)
    # 분석한 감정에 나타난 수치를 0에서1 값으로 표현하기위해 100으로 나누는 코드입니다.
    normalizedConfidence = response["document"]["confidence"][maxConfidence] / 100
    # 분석한 감정이 부정적이라면 감정수치에 마이너스를 곱해서 감정수치를 -1에서1 값으로 표현합니다.
    if str(response["document"]["sentiment"]) == "negative":
        normalizedConfidence *= -1 
    return {"sentimentValue" : normalizedConfidence}
    #test
    return {"sentimentValue" : 0.7}

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