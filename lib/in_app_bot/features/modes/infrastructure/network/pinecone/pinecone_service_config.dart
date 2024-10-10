import 'package:flutter_dotenv/flutter_dotenv.dart';

class PineconeServiceConfig {
  static String get indexName => dotenv.env['PINECONE_INDEX_NAME'] ?? '';
  static String get projectId => dotenv.env['PINECONE_PROJECT_ID'] ?? '';
  static int get topK => int.tryParse(dotenv.env['PINECONE_TOP_K'] ?? '5') ?? 5;
  static String get baseUrl => dotenv.env['PINECONE_BASE_URL'] ?? '';
}
