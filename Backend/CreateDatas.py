import csv
from TextDatas import texts
import json
import requests

csvDatas = []
client_id = "clientId"
client_secret = "clientSecret"
apiUrl="https://naveropenapi.apigw.ntruss.com/sentiment-analysis/v1/analyze"
headers = {
    "X-NCP-APIGW-API-KEY-ID": client_id,
    "X-NCP-APIGW-API-KEY": client_secret,
    "Content-Type": "application/json"
}


def classifyEmotion(inputText: str) -> float:
    # request naver sentiment api and return emotion value
    data = {"content" : inputText}
    response = requests.post(apiUrl, data=json.dumps(data), headers=headers).json()
    if response["document"]["sentiment"] == "neutral":
        sentimentValue = 0
        positiveValue = response["document"]["confidence"]["positive"]
        negativeValue = response["document"]["confidence"]["negative"]
        if positiveValue > negativeValue:
            sentimentValue = positiveValue
        else:
            sentimentValue = -negativeValue
        return round(sentimentValue, 4)
    else:
        maxConfidence = max(response["document"]["confidence"], key= response["document"]["confidence"].get)
        # 분석한 감정에 나타난 수치를 0에서1 값으로 표현하기위해 100으로 나누는 코드입니다.
        normalizedConfidence = response["document"]["confidence"][maxConfidence] / 100
        # 분석한 감정이 부정적이라면 감정수치에 마이너스를 곱해서 감정수치를 -1에서1 값으로 표현합니다.
        if str(response["document"]["sentiment"]) == "negative":
            normalizedConfidence *= -1
        return round(normalizedConfidence, 4)

contentsLabel = {
    "영화" : 0,
    "책" : 1,
    "음악" : 2,
    "산책" : 3,
    "운동" : 4,
    "유튜브" : 5,
    "쇼핑" : 6
}

for text in texts.keys():
    emotionValue = classifyEmotion(inputText= text)
    csvDatas.append({
        "Emotion value" : emotionValue, 
        "Content" : contentsLabel[texts[text]]
        })

csv_file_path = "data.csv"

# CSV 파일 쓰기
with open(csv_file_path, mode= 'w', newline= '', encoding= 'utf-8') as file:
    fieldnames = ["Emotion value", "Content"]
    writer = csv.DictWriter(file, fieldnames= fieldnames)

    writer.writeheader()
    for row in csvDatas:
        writer.writerow(row)

print("Done.")