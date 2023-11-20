from fastapi import FastAPI
import requests
import json
# uvicorn main:app --reload

# init
app = FastAPI()
client_id = "your client id"
client_secret = "your client secret"
apiUrl="https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"

headers = {
    "X-NCP-APIGW-API-KEY-ID": client_id,
    "X-NCP-APIGW-API-KEY": client_secret,
    "Content-Type": "application/json"
}

@app.get("/recommend")
async def recommend(inputText: str):
    data = {"content" : inputText}
    response = requests.post(apiUrl, data=json.dumps(data), headers=headers).json()
    maxConfidence = max(response["document"]["confidence"], key=response["document"]["confidence"].get)

    # 분석한 감정에 나타난 수치를 0에서1 값으로 표현하기위해 100으로 나누는 코드입니다.
    normalizedConfidence = response["document"]["confidence"][maxConfidence] / 100

    # 분석한 감정이 부정적이라면 감정수치에 마이너스를 곱해서 감정수치를 -1에서1 값으로 표현합니다.
    if str(response["document"]["sentiment"]) == "negative":
        normalizedConfidence *= -1

    # 여기에 -1에서1 값으로 표현된 감정수치를 조건에따라 0.5단위로 나누어서 추천할 콘텐츠들을 조사해주셔서 작성해주시면 될 것 같아요
    # 예를들어 코드는 아래와 같습니다
    content = "콘텐츠없음"
    if normalizedConfidence <= 1 and normalizedConfidence > 0.5:   # 감정이 매우 긍정적인 상태
        content = "매우 긍정적인 감정일때 하면 좋을 콘텐츠"
    elif normalizedConfidence <= 0.5 and normalizedConfidence > 0:    # 감정이 조금 긍정적인 상태
        content = "조금 긍정적인 감정일때 하면 좋을 콘텐츠"
    elif normalizedConfidence == 0:    # 감정이 중립일때 하면 좋을 콘텐츠
        content = "중립 감정일때 하면 좋을 콘텐츠"
    elif normalizedConfidence < 0 and normalizedConfidence > -0.5:    # 감정이 조금 부정적인 상태
        content = "조금 부정적인 감정일때 하면 좋을 콘텐츠"
    elif normalizedConfidence <= -0.5 and normalizedConfidence >= -1:    # 감정이 매우 부정적인 상태
        content = "매우 부정적인 감정일때 하면 좋을 콘텐츠"

    return {
        "recommend" : content,
        "sentimentValue" : normalizedConfidence
    }

# @app.get("/recommend")
# async def recommend(value: float, age: str, hobby: str):
#     print(value, age, hobby)
#     return {"recommend" : "애니메이션"}