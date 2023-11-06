from fastapi import FastAPI

app = FastAPI()

# uvicorn main:app --reload

@app.get("/")
async def hello(name: str):
    return {"messages" : "hello"}