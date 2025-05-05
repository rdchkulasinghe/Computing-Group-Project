import 'dart:convert';
import 'package:http/http.dart' as http;

class OpenAIService {
  final String apiKey =
      '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'; // nancy key
  final String apiUrl = 'https://api.openai.com/v1/chat/completions';

  Future<String> getAIResponse(String userMessage) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $apiKey',
        },
        body: jsonEncode({
          "model": "gpt-3.5-turbo",
          "messages": [
            {
              "role": "system",
              "content":
                  "You are a caring, supportive mental health assistant named Nancy. Always respond with warmth, empathy, and encouragement."
            },
            {
              "role": "user",
              "content": userMessage,
            }
          ],
          "temperature": 0.7,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['choices'][0]['message']['content'];
      } else {
        return "Error: ${response.statusCode} - ${response.body}";
      }
    } catch (e) {
      return "An error occurred: $e";
    }
  }
}
