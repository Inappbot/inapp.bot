import 'package:flutter_riverpod/flutter_riverpod.dart';

final flashStateProvider = StateProvider<bool>((ref) => false);
final scannedStateProvider = StateProvider<bool>((ref) => false);
final backButtonEnabledProvider = StateProvider<bool>((ref) => true);
final productDataProvider = StateProvider<Map<String, dynamic>?>((ref) => null);
final flashButtonEnabledProvider = StateProvider<bool>((ref) => false);
