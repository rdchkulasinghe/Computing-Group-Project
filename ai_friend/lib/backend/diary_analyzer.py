import firebase_admin
from firebase_admin import credentials, firestore
from textblob import TextBlob
import re
import nltk
from nltk.corpus import stopwords
from collections import defaultdict
from datetime import datetime, timedelta
import pytz

from transformers import pipeline

# Firebase Setup
cred = credentials.Certificate("lib/backend/nancy-the-ai-firebase-adminsdk-fbsvc-1ea625e660.json")
firebase_admin.initialize_app(cred)
db = firestore.client()

# NLTK Resources
try:
    nltk.data.find('tokenizers/punkt')
    nltk.data.find('corpora/stopwords')
except LookupError:
    nltk.download('punkt')
    nltk.download('stopwords')


# ---------------------- OCCASION DETECTOR ----------------------
class OccasionDetector:
    def __init__(self):
        self.classifier = pipeline("zero-shot-classification", model="facebook/bart-large-mnli")
        self.labels = ["birthday", "vacation", "exam", "breakup", "achievement", "health"]

    def detect_occasion(self, content):
        if not content or not isinstance(content, str):
            return None
        try:
            content = content.strip().lower()
            result = self.classifier(content, self.labels)
            top_label = result['labels'][0]
            score = result['scores'][0]
            return top_label if score > 0.5 else None
        except Exception as e:
            print(f"Occasion detection error: {e}")
            return None


# ---------------------- SENTIMENT ANALYZER ----------------------
class SentimentAnalyzer:
    def __init__(self):
        self.stop_words = set(stopwords.words('english'))
        self.emoji_sentiment = {
            ':)': 'positive', ':-)': 'positive', '(:': 'positive',
            ':(': 'negative', ':-(': 'negative', '):': 'negative',
            ':|': 'neutral', ':-|': 'neutral',
            ';)': 'positive', ';-)': 'positive',
            ':D': 'positive', ':-D': 'positive',
            ':P': 'positive', ':-P': 'positive',
            ':/': 'negative', ':-/': 'negative',
            ':O': 'neutral', ':-O': 'neutral'
        }

    def preprocess_text(self, text):
        if not text or not isinstance(text, str):
            return ""
        for emoji, sentiment in self.emoji_sentiment.items():
            text = text.replace(emoji, f' {sentiment} ')
        text = re.sub(r'[^a-zA-Z0-9\s.,!?]', '', text)
        words = nltk.word_tokenize(text)
        words = [w for w in words if w.lower() not in self.stop_words]
        return ' '.join(words)

    def get_sentiment(self, text):
        processed_text = self.preprocess_text(text)
        analysis = TextBlob(processed_text)
        polarity = analysis.sentiment.polarity

        if polarity > 0.3:
            return "very positive"
        elif polarity > 0.1:
            return "positive"
        elif polarity < -0.3:
            return "very negative"
        elif polarity < -0.1:
            return "negative"
        return "neutral"


# ---------------------- TEMPORAL ANALYSIS ----------------------
def analyze_temporal_patterns(user_id, timezone='UTC'):
    try:
        tz = pytz.timezone(timezone)
        end_date = datetime.now(tz)
        start_date = end_date - timedelta(days=365)

        diaries = db.collection("diaries").filter(
            filter=firestore.FieldFilter("user_id", "==", user_id)
        ).filter(
            filter=firestore.FieldFilter("timestamp", ">=", start_date)
        ).filter(
            filter=firestore.FieldFilter("timestamp", "<=", end_date)
        ).get()

        monthly_stats = defaultdict(lambda: {
            'count': 0,
            'positive': 0,
            'negative': 0,
            'neutral': 0,
            'occasions': defaultdict(int)
        })

        for doc in diaries:
            data = doc.to_dict()
            timestamp = data.get('timestamp')
            if not isinstance(timestamp, datetime):
                continue
            date = timestamp.astimezone(tz)
            month_key = f"{date.year}-{date.month:02d}"

            monthly_stats[month_key]['count'] += 1
            sentiment = data.get('sentiment', 'neutral')
            monthly_stats[month_key][sentiment] += 1

            occasion = data.get('occasion')
            if occasion:
                monthly_stats[month_key]['occasions'][occasion] += 1

        return monthly_stats
    except Exception as e:
        print(f"Error in temporal analysis: {e}")
        return {}


# ---------------------- DIARY ANALYZER ----------------------
def analyze_diaries():
    try:
        occasion_detector = OccasionDetector()
        sentiment_analyzer = SentimentAnalyzer()

        two_years_ago = datetime.now() - timedelta(days=730)
        diaries = db.collection_group("diaryEntries")\
                    .where("date", ">=", two_years_ago)\
                    .get()

        batch = db.batch()
        batch_count = 0
        max_batch_size = 500

        for doc in diaries:
            data = doc.to_dict()
            content = data.get("content", "")

            sentiment = sentiment_analyzer.get_sentiment(content)
            occasion = occasion_detector.detect_occasion(content)

            print(f"Document ID: {doc.id}")
            print(f"Sentiment: {sentiment}")
            print(f"Occasion: {occasion}")
            print("-----")

            update_data = {
                "sentiment": sentiment,
                "occasion": occasion,
                "word_count": len(content.split()),
                "char_count": len(content),
                "reading_time": max(1, len(content.split()) // 200),
                "last_analyzed": datetime.now()
            }

            doc_ref = doc.reference
            batch.update(doc_ref, update_data)
            batch_count += 1

            if batch_count >= max_batch_size:
                batch.commit()
                batch = db.batch()
                batch_count = 0

        if batch_count > 0:
            batch.commit()

    except Exception as e:
        print(f"Error in diary analysis: {e}")


# ---------------------- MAIN ----------------------
if __name__ == "__main__":
    analyze_diaries()
