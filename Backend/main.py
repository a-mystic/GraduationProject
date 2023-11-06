from fastapi import FastAPI

app = FastAPI()

# uvicorn main:app --reload

@app.get("/")
async def hello():
    return {"recommend" : "애니메이션"}