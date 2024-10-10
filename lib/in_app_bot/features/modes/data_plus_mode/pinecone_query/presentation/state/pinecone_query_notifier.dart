import 'dart:developer';
import 'dart:ui';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/modes/data_plus_mode/pinecone_query/presentation/state/query_result_state.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/pinecone/pinecone_query_service.dart';
import 'package:in_app_bot/in_app_bot/features/modes/infrastructure/network/pinecone/pinecone_service_config.dart';

final searchQueryProvider =
    StateNotifierProvider<PineconeQueryNotifier, QueryResultState>(
  (ref) => PineconeQueryNotifier(ref),
);

class PineconeQueryNotifier extends StateNotifier<QueryResultState> {
  final Ref ref;
  VoidCallback? onResponseReady;
  String concatPageContent = '';

  PineconeQueryNotifier(this.ref)
      : super(QueryResultState(result: '', state: QueryStatus.initial));

  void setOnResponseReady(VoidCallback callback) => onResponseReady = callback;

  Future<void> fetchPineconeIndexResults(String query,
      [VoidCallback? onResponse]) async {
    _setStateFromQueryResult(QueryStatus.loading, '');
    try {
      final result = await ref
          .read(pineconeQueryServiceProvider)
          .performPineconeVectorSearch(PineconeServiceConfig.indexName, query);
      _handleQueryResult(result);
      if (onResponse != null) onResponse();
    } catch (e) {
      _setStateFromQueryResult(QueryStatus.error, '');
      log('Error on fetchPineconeIndexResults: $e');
    }
  }

  void _setStateFromQueryResult(QueryStatus status, String result) {
    state = QueryResultState(result: result, state: status);
  }

  void _handleQueryResult(String result) {
    _setStateFromQueryResult(QueryStatus.loaded, result);
    if (onResponseReady != null) onResponseReady!();
  }
}
