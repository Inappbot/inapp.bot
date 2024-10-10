import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedPageIndexProvider = StateProvider<int>((ref) => 0);
final imageSizeProvider = StateProvider<double>((ref) => 100.0);
