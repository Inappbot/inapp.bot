import 'dart:async';

List<Timer> timers = [];
List<Timer> timersFirst = [];
List<Timer> timers3 = [];

void cancelPreviousTimers(List<Timer> targetTimers) {
  for (var timer in targetTimers) {
    timer.cancel();
  }
  targetTimers.clear();
}
