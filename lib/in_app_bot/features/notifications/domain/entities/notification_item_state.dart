class NotificationItemState {
  final bool isInitialized;
  final bool isLoaded;
  final bool isPlaying;
  final bool isRead;

  NotificationItemState({
    this.isInitialized = false,
    this.isLoaded = false,
    this.isPlaying = false,
    this.isRead = false,
  });

  NotificationItemState copyWith({
    bool? isInitialized,
    bool? isLoaded,
    bool? isPlaying,
    bool? isRead,
  }) {
    return NotificationItemState(
      isInitialized: isInitialized ?? this.isInitialized,
      isLoaded: isLoaded ?? this.isLoaded,
      isPlaying: isPlaying ?? this.isPlaying,
      isRead: isRead ?? this.isRead,
    );
  }
}
