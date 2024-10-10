import 'dart:developer';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

Future<String> downloadAndCacheVideo(
    String url, String fileName, String avatarId) async {
  try {
    final directory = await getApplicationDocumentsDirectory();
    final avatarDirectory =
        Directory('${directory.path}/assets/avatars/$avatarId');
    log('id del avatar: $avatarId');

    if (!await avatarDirectory.exists()) {
      await avatarDirectory.create(recursive: true);
    }

    final file = File('${avatarDirectory.path}/$fileName');

    if (await file.exists()) {
      log("File loaded from cache: ${file.path}");
    } else {
      final response = await http.get(Uri.parse(url));
      await file.writeAsBytes(response.bodyBytes);
      log("File downloaded and cached: ${file.path}");
    }

    return file.path;
  } catch (e) {
    log('Error downloading or caching video: $e');
    return Future.error('Error downloading or caching video');
  }
}
