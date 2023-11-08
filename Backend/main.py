from fastapi import FastAPI

app = FastAPI()

# uvicorn main:app --reload

@app.get("/recommend")
async def recommend(value: float, age: str, hobby: str):
    print(value, age, hobby)
    return {"recommend" : "애니메이션"}