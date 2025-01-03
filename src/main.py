from fastapi import FastAPI
from pydantic import BaseModel

app = FastAPI(title="Python Web API Demo")

class Message(BaseModel):
    content: str

@app.get("/")
async def root():
    return {"message": "Welcome to Python Web API Demo"}

@app.post("/echo")
async def echo(message: Message):
    return {"echo": message.content}

if __name__ == "__main__":
    import uvicorn
    uvicorn.run(app, host="0.0.0.0", port=8000) 