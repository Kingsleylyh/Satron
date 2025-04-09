import 'dart:convert';
import 'package:http/http.dart' as http;

class GeminiService {
  final String apiKey;

  GeminiService({required this.apiKey});

  Future<String?> getRouteSuggestions(String origin, String destination) async {
    final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-pro:generateContent?key=$apiKey');

    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode({
      'contents': [
        {
          'parts': [
            {
              'text': "Suggest a detailed public transport route from $origin to $destination in Malaysia using common services like MRT, LRT, or RapidKL buses. Keep it brief but clear."
            }
          ]
        }
      ]
    });

    final response = await http.post(url, headers: headers, body: body);

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return json['candidates'][0]['content']['parts'][0]['text'];
    } else {
      print('Failed to get response: ${response.statusCode}');
      return null;
    }
  }
}
