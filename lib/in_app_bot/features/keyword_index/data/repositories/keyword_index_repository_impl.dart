import 'package:in_app_bot/in_app_bot/features/keyword_index/data/services/keyword_index_repository.dart';
import 'package:in_app_bot/in_app_bot/features/keyword_index/domain/repositories/keyword_index_fetch_service.dart';

class KeywordIndexRepositoryImpl implements KeywordIndexRepository {
  @override
  Future<List<Map<String, dynamic>>> fetchAllDocuments() async {
    return await KeywordIndexService.fetchAllDocuments();
  }
}
