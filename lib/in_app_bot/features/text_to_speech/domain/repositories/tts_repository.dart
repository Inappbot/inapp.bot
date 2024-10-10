abstract class TtsRepository {
  Future<void> initializeTts();
  Future<void> speak(String message);
  Future<void> stop();
  Future<void> reset();
  Future<void> setVolume(double volume);
  Stream<bool> get playingStateStream;
}
