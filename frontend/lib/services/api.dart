import 'dart:convert';
import 'package:http/http.dart' as http;

class Api {
  static const String chatbotUrl = 'http://localhost:8000/chatbot';

  // POST request for text
  static Future<Map<String, dynamic>?> postTextAnalysis(String text) async {
    try {
      final response = await http.post(
        Uri.parse('$chatbotUrl/response/'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'message': text}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('response')) {
          final aiResponse = data['response'];
          return {
            'analysis_type': 'text',
            'main_claim': aiResponse['main_claim'] ?? 'No claim extracted',
            'verdict': aiResponse['verdict'] ?? 'Unclear',
            'rating': aiResponse['rating'] ?? 50,
            'reasoning': aiResponse['reasoning'] ?? 'Analysis completed',
            'web_links': aiResponse['web_links'] ?? [],
            'date': DateTime.now().toIso8601String(),
          };
        }
        return data;
      } else {
        print('Error: ${response.statusCode} - ${response.body}');
        return {
          'error': 'Failed to analyze text',
          'status_code': response.statusCode,
        };
      }
    } catch (e) {
      print('Exception occurred: $e');
      return {'error': 'Network error occurred', 'details': e.toString()};
    }
  }
}
