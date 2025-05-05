import firebase_admin
from firebase_admin import credentials, firestore
from datetime import datetime, timezone
from analyze_user_tone import analyze_tone  

# Initialize Firebase only if not already initialized
if not firebase_admin._apps:
    cred = credentials.Certificate("lib/backend/nancy-the-ai-firebase-adminsdk-fbsvc-1ea625e660.json")
    firebase_admin.initialize_app(cred)

db = firestore.client()

def should_reanalyze(user_id, threshold=20):
    user_doc = db.collection("users").document(user_id).get()
    user_data = user_doc.to_dict()

    last_analyzed = user_data.get("toneProfile", {}).get("lastAnalyzed")
    if last_analyzed:
        if isinstance(last_analyzed, datetime):
            last_analyzed = last_analyzed.replace(tzinfo=timezone.utc)
        else:
            last_analyzed = datetime.fromisoformat(last_analyzed.replace("Z", "+00:00"))
    else:
        # Never analyzed before
        return True

    # Count new user messages since last analysis
    new_msgs = db.collection("chats")\
        .where("userId", "==", user_id)\
        .where("sender", "==", "user")\
        .where("time", ">", last_analyzed)\
        .stream()

    return sum(1 for _ in new_msgs) >= threshold

def trigger_if_ready(user_id):
    if should_reanalyze(user_id):
        print(f" Analyzing tone for user {user_id}...")
        analyze_tone(user_id)
    else:
        print(f" User {user_id} has not reached message threshold for analysis.")

def run_weekly_analysis_for_all_users():
    print(" Starting weekly tone analysis check...")
    users = db.collection("users").stream()
    for user in users:
        user_id = user.id
        trigger_if_ready(user_id)
    print(" Weekly tone analysis complete.")

# Trigger the full weekly scan
#if __name__ == "__main__":
 #   run_weekly_analysis_for_all_users()
