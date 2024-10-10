import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

// Gemini api key

class GeminiApiService {
  final WidgetRef ref;

  GeminiApiService(this.ref);

  Future<String?> getGeminiApiKey() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final String? idToken = await user.getIdToken(true);

        final String? apiUrl = dotenv.env['GEMINI_API_KEY'];
        if (apiUrl == null || apiUrl.isEmpty) {
          throw Exception('API URL is not defined in .env');
        }

        final response = await http.get(
          Uri.parse(apiUrl),
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        );

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return data['apiKey'];
        } else {
          return null;
        }
      } catch (e) {
        return null;
      }
    } else {
      throw Exception('User not authenticated');
    }
  }
}
