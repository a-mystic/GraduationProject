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

@app.get("/analyzeEmotion")
async def analyzeEmotion(inputText: str):
    data = {"content" : inputText}
    response = requests.post(apiUrl, data=json.dumps(data), headers=headers).json()
    maxConfidence = max(response["document"]["confidence"], key=response["document"]["confidence"].get)
    print(response["document"]["confidence"][maxConfidence] / 100)
    return {
        "sentiment" : str(response["document"]["sentiment"]),
        "confidence" : str(response["document"]["confidence"])
        }

@app.get("/recommend")
async def recommend(value: float, age: str, hobby: str):
    print(value, age, hobby)
    return {"recommend" : "애니메이션"}