import 'package:url_launcher/url_launcher.dart';

class UrlLauncherHelper {
  static Future<void> launchUrlHelper(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      throw 'Could not launch $url';
    }
  }
}
