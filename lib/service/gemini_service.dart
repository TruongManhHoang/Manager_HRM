import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey = 'AIzaSyDniKq5uWeSSZUrZ4pR8tAQMTte3tK-Cd0';

  final String apiUrl =
      'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent';

  Future<String> chatWithGemini(String userMessage) async {
    final response = await http.post(
      Uri.parse('$apiUrl?key=$apiKey'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "contents": [
          {
            "parts": [
              {"text": userMessage}
            ]
          }
        ]
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['candidates'][0]['content']['parts'][0]['text'];
      return content;
    } else {
      print('Lỗi: ${response.body}');
      return "Lỗi API: ${jsonDecode(response.body)['error']['message']}";
    }
  }
}
