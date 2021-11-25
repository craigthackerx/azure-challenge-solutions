from fastapi import FastAPI

app = FastAPI()

@app.get("/")
async def root():
    return {"message": "Welcome to CyberScot API"}

@app.get("/hello-world")
async def root():
    return {"message": "Hello World"}