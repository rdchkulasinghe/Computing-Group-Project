import firebase_admin
from firebase_admin import credentials, firestore
from typing import Optional, List, Dict, Any
import nltk
from textblob import TextBlob
import emoji
import re
import statistics
from datetime import datetime

# Initialize Firebase Admin
def initialize_firestore() -> firestore.Client:
    cred = credentials.Certificate("lib/backend/nancy-the-ai-firebase-adminsdk-fbsvc-1ea625e660.json")
    firebase_admin.initialize_app(cred)
    return firestore.client()

db = initialize_firestore()

# Utility: Count emojis in text
def count_emojis(text: str) -> int:
    return sum(1 for c in text if c in emoji.EMOJI_DATA)

# Utility: Detect metaphorical expressions
def metaphor_likelihood(text: str) -> bool:
    metaphor_pattern = re.compile(r"\b(like|as|seems|similar to|reminds me)\b", re.IGNORECASE)
    return bool(metaphor_pattern.search(text))

# Core analysis logic for a batch of messages
def analyze_messages(messages: List[str]) -> Dict[str, Any]:
    if not messages:
        return {}
    
    sentiments = []
    lengths = []
    metaphor_count = 0
    emoji_count_total = 0

    for msg in messages:
        blob = TextBlob(msg)
        sentiments.append(blob.sentiment.polarity)
        lengths.append(len(msg.split()))
        metaphor_count += int(metaphor_likelihood(msg))
        emoji_count_total += count_emojis(msg)

    avg_sentiment = statistics.mean(sentiments) if sentiments else 0
    avg_length = statistics.mean(lengths) if lengths else 0
    total_messages = len(messages)

    # Tone classification
    if avg_sentiment > 0.2:
        tone = "positive and engaging"
    elif avg_sentiment < -0.1:
        tone = "critical or concerned"
    else:
        tone = "neutral and reflective"

    # Style detection
    style_features = []
    if (metaphor_count / total_messages) > 0.2:
        style_features.append("uses metaphors")
    if (emoji_count_total / total_messages) > 0.1:
        style_features.append("frequent emoji usage")
    if avg_length > 20:
        style_features.append("detailed writing style")
    elif avg_length < 8:
        style_features.append("concise communication")

    return {
        "tone": tone,
        "style": ", ".join(style_features) if style_features else "neutral",
        "avgMessageLength": round(avg_length, 1),
        "sentimentScore": round(avg_sentiment, 2),
        "metaphorFrequency": f"{metaphor_count}/{total_messages}",
        "emojiFrequency": f"{emoji_count_total}/{total_messages}",
        "lastAnalyzed": datetime.utcnow().isoformat() + "Z"
    }

# Firestore-integrated tone analysis
def analyze_tone(user_id: str) -> Optional[Dict[str, Any]]:
    try:
        query = (
            db.collection("chats")
            .where("userId", "==", user_id)
            .order_by("time")
        )
        
        messages = [doc.get("message") for doc in query.stream() if "message" in doc.to_dict()]


        if not messages:
            print(f"No messages found for user {user_id}")
            return None

        analysis_result = analyze_messages(messages)

        # Update user's toneProfile
        user_ref = db.collection("users").document(user_id)
        user_ref.update({
            "toneProfile": analysis_result,
            "metrics.lastUpdated": firestore.SERVER_TIMESTAMP
        })

        return analysis_result

    except Exception as e:
        print(f"Error analyzing tone for user {user_id}: {str(e)}")
        return None

# Run analysis (for testing)
if __name__ == "__main__":
    result = analyze_tone("pCMOoO0GQsSUOtY37OaQzque6lC3")
    if result:
        print("Analysis completed:", result)
