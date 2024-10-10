import 'dart:developer';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/data/services/api_key_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/pinecone/pinecone_service_config.dart';
import 'package:langchain_openai/langchain_openai.dart';
import 'package:pinecone/pinecone.dart';

abstract class PineconeQueryService {
  Future<String> performPineconeVectorSearch(String indexName, String query);
}

final pineconeQueryServiceProvider = Provider<PineconeQueryService>((ref) {
  final apiKeyService = ApiKeyService(ref);
  return PineconeQueryServiceImpl(apiKeyService: apiKeyService);
});

class PineconeQueryServiceImpl implements PineconeQueryService {
  final ApiKeyService apiKeyService;
  PineconeClient? _client;
  OpenAIEmbeddings? _embeddings;

  PineconeQueryServiceImpl({required this.apiKeyService});

  Future<void> _initializeServices() async {
    if (_client == null || _embeddings == null) {
      final apiKeys = await apiKeyService.getPineconeAndOpenAiApiKeys();
      if (apiKeys != null) {
        _client = PineconeClient(
            apiKey: apiKeys['pineconeApiKey']!,
            baseUrl: PineconeServiceConfig.baseUrl);
        _embeddings = OpenAIEmbeddings(apiKey: apiKeys['openAiApiKey']!);
      } else {
        throw Exception(
            'Failed to initialize services: API keys not available');
      }
    }
  }

  @override
  Future<String> performPineconeVectorSearch(
      String indexName, String query) async {
    await _initializeServices();
    try {
      final queryEmbedding = await _embeddings!.embedQuery(query);
      final result = await _client!.queryVectors(
        indexName: indexName,
        projectId: PineconeServiceConfig.projectId,
        request: QueryRequest(
          topK: PineconeServiceConfig.topK,
          vector: queryEmbedding,
          includeMetadata: true,
          includeValues: true,
          // namespace: 'inappbot',
        ),
        environment: '',
      );

      if (result.matches.isNotEmpty) {
        for (var match in result.matches) {
          log('Document Metadata: ${match.metadata}');
          if (match.metadata?['sentence'] != null &&
              match.metadata?['sentence'].isNotEmpty) {
            log('Document Content: ${match.metadata?['sentence']}');
          } else {
            log('Empty or null page content found in a match');
          }
        }
        final concatPageContent =
            result.matches.map((e) => e.metadata?['sentence'] ?? '').join(' ');
        return concatPageContent;
      } else {
        return 'No results found';
      }
    } catch (e) {
      log('Error en performPineconeVectorSearch: $e');
      throw Exception('Error querying pinecone index');
    }
  }
}
