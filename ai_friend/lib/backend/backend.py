from fastapi import FastAPI, HTTPException
from pymongo import MongoClient
import openai
import firebase_admin
from firebase_admin import credentials, auth

# Initialize Firebase Admin SDK
cred = credentials.Certificate("path/to/firebase_credentials.json")
firebase_admin.initialize_app(cred)

# Connect to MongoDB
client = MongoClient("mongodb+srv://wangdaiyu532:<Pnb03msn>@cluster0.kk66p.mongodb.net/?retryWrites=true&w=majority&appName=Cluster0")
db = client["chatbotDB"]
users_collection = db["users"]

# OpenAI API Key
openai.api_key = "your_openai_api_key"

app = FastAPI()

@app.post("/register_user/")
async def register_user(user_data: dict):
    """Stores user preferences in MongoDB"""
    existing_user = users_collection.find_one({"uid": user_data["uid"]})
    if existing_user:
        return {"message": "User already exists"}
    
    users_collection.insert_one(user_data)
    return {"message": "User registered successfully"}

@app.post("/chat/")
async def chat(user_id: str, message: str):
    """Processes user message and returns chatbot response"""
    user_data = users_collection.find_one({"uid": user_id})
    if not user_data:
        raise HTTPException(status_code=404, detail="User not found")

    # Customizing AI response based on user preference
    user_info = f"User is {user_data['age']} years old, prefers {user_data['movie_preference']} movies, enjoys {user_data['hobbies']}."
    prompt = f"{user_info} The user says: {message}. How should I respond?"
    
    response = openai.ChatCompletion.create(
        model="gpt-4-turbo",
        messages=[{"role": "system", "content": "You are a friendly and emotionally supportive chatbot."},
                  {"role": "user", "content": prompt}]
    )
    
    return {"response": response["choices"][0]["message"]["content"]}

# Run the server with:
# uvicorn backend:app --host 0.0.0.0 --port 8000 --reload
