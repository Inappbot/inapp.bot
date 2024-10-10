import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

//openai and pinecone api keys

class ApiKeyService {
  final Ref ref;
  ApiKeyService(this.ref);

  Future<Map<String, String>?> getPineconeAndOpenAiApiKeys() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        final String? idToken = await user.getIdToken(true);
        final response = await http.get(
          Uri.parse(dotenv.env['API_ENDPOINT'] ?? ''),
          headers: {
            'Authorization': 'Bearer $idToken',
          },
        );
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          return {
            'pineconeApiKey': data['pineconeApiKey'],
            'openAiApiKey': data['openAiApiKey'],
          };
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
