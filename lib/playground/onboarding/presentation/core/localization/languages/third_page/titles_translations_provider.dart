import 'package:flutter_riverpod/flutter_riverpod.dart';

final titlesByLanguageProvider = Provider<Map<String, Map<int, String>>>((ref) {
  return {
    'en': {
      2: 'Receive News and Updates',
    },
    'es': {
      2: 'Recibe Noticias y Novedades',
    },
    'hi': {
      2: 'समाचार और नवीनतम जानकारी प्राप्त करें',
    },
  };
});
