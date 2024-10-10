enum QueryStatus { initial, loading, loaded, error }

class QueryResultState {
  final String result;
  final QueryStatus state;

  QueryResultState({
    required this.result,
    required this.state,
  });

  QueryResultState copyWith({String? result, QueryStatus? state}) =>
      QueryResultState(
        result: result ?? this.result,
        state: state ?? this.state,
      );
}
