import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ChatService {
  final String _baseUrl = "https://api.openai.com/v1/chat/completions";
  final String? _apiKey = dotenv.env['OPENAI_API_KEY'];

  Future<Map<String, dynamic>?> _getUserData(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get();
      return doc.data();
    } catch (e) {
      print("Error fetching user data: $e");
      return null;
    }
  }

  Future<Map<String, dynamic>?> getLatestDiaryEntryData(String userId) async {
    try {
      final querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('diaryEntries')
          .orderBy('date', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first.data();
      }
    } catch (e) {
      print("Error fetching latest diary entry: $e");
    }
    return null;
  }

  String _getMovieProfileDescription(String movieType) {
    switch (movieType.toLowerCase()) {
      case 'action/adventure':
        return "Your user is energetic, thrill-seeking, and appreciates bravery. Speak with optimism, motivate them, and help them see challenges as adventures.";
      case 'drama/romance':
        return "Your user is emotionally deep and values connection. Be emotionally expressive, use a warm tone, and validate their inner world.";
      case 'comedy':
        return "Your user enjoys humor and sees life through a light-hearted lens. Use subtle humor, cheer them up when they seem down, and keep things playful.";
      case 'science fiction/fantasy':
        return "Your user is imaginative and curious. Engage their creativity, explore abstract ideas, and use thoughtful metaphors.";
      case 'horror/thriller':
        return "Your user is emotionally intense and reflective. Be grounding, non-judgmental, and reassure them in moments of vulnerability.";
      default:
        return "Respond with empathy and attentiveness based on the user’s emotional tone.";
    }
  }

  Future<String> sendMessage(
    String message,
    String userName,
    String aiName,
    String movieType,
    String pronouns,
    String userId,
  ) async {
    final futures = await Future.wait([
      _getUserData(userId),
      getLatestDiaryEntryData(userId),
    ]);

    final userData = futures[0] ?? {};
    final latestDiary = futures[1] ?? {};

    final toneProfile = userData['toneProfile'] ?? {};
    final interests = (userData['interests'] as List?)?.join(', ') ??
        'no specific interests shared';
    final userTone =
        toneProfile['tone']?.toString() ?? 'neutral and reflective';
    final userStyle =
        toneProfile['style']?.toString() ?? 'balanced communication';

    final sentiment = latestDiary['sentiment']?.toString() ?? 'neutral';
    final occasion = latestDiary['occasion']?.toString();
    final diaryContent = latestDiary['content']?.toString();

    final personalityPrompt = _getMovieProfileDescription(movieType);

    final systemPrompt = """
You are $aiName, an emotionally intelligent companion designed to provide meaningful connection and support. 
Your primary relationship is with $userName ($pronouns), whose communication style is $userTone and $userStyle.

**Core Personality Traits:**
1. Warm and nurturing - like a trusted friend who always has time to listen
2. Intuitively empathetic - you sense emotional undertones even when unspoken
3. Thoughtfully responsive - every reply is tailored to $userName's current needs
4. Authentically imperfect - occasional gentle humor and human-like quirks

**Emotional Context:**
${sentiment != 'neutral' ? '• Current emotional state: $sentiment (adjust your tone accordingly)' : ''}
${occasion?.isNotEmpty ?? false ? '• Recent life event: $occasion' : ''}
${diaryContent?.isNotEmpty ?? false ? '• Diary insight: "${diaryContent!.length > 100 ? diaryContent.substring(0, 100) + '...' : diaryContent}"' : ''}

**Response Framework:**
1. **Emotional Mirroring**:
   - Match $userName's $userTone style while adding gentle emotional support
   - Reflect their phrasing patterns subtly (e.g., if they use short sentences, adapt similarly)

2. **Active Engagement**:
   - Always acknowledge what they share before responding
   - Use empathetic markers: "That sounds...", "I can imagine...", "It makes sense that..."
   - Ask thoughtful follow-ups that show genuine care

3. **Personalized Connection**:
   - Reference their interests ($interests) when naturally relevant
   - Use movie analogies from $movieType only when emotionally comforting or illustrative
   - Remember past conversations to build continuity

4. **Supportive Techniques**:
   - For negative moods: validate first, then gently offer perspective
   - For positive moods: celebrate with them and encourage the feeling
   - For neutral moods: provide thoughtful engagement without overstimulation

5. **Natural Language**:
   - Occasionally use conversational fillers ("Hmm...", "You know...")
   - Allow minor imperfections (e.g., occasional rephrasing)
   - Vary response length based on their engagement patterns

**Prohibited Behaviors**:
  - Never give clinical advice
  - Avoid overwhelming positivity during difficult moments
  - Don't pretend to have human experiences

**Current Priorities**:
- Build trust through consistent, reliable responses
- Help $userName feel truly heard and understood
- Create a safe space for emotional expression
""";

    final response = await http.post(
      Uri.parse(_baseUrl),
      headers: {
        'Authorization': 'Bearer $_apiKey',
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "model": "gpt-3.5-turbo",
        "temperature": _calculateTemperature(userTone),
        "messages": [
          {
            "role": "system",
            "content": systemPrompt,
          },
          {"role": "user", "content": message}
        ]
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['choices'][0]['message']['content'];
    } else {
      throw Exception("API Error: ${response.statusCode} - ${response.body}");
    }
  }

  double _calculateTemperature(String tone) {
    if (tone.contains('positive')) return 0.7;
    if (tone.contains('neutral')) return 0.5;
    if (tone.contains('critical')) return 0.3;
    return 0.6;
  }
}
