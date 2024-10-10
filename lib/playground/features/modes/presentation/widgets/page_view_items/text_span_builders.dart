import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/features/modes/presentation/widgets/page_view_items/interactive_spans.dart';
import 'package:in_app_bot/playground/features/modes/presentation/widgets/page_view_items/video_player_widget.dart';
import 'package:in_app_bot/playground/presentation/theme/text_styles.dart';
import 'package:lottie/lottie.dart';
import 'package:url_launcher/url_launcher.dart';

class TextSpanBuilders {
  static InlineSpan buildBoldSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    return TextSpan(
      text: matchedText,
      style: TextStyles.bold,
    );
  }

  static InlineSpan buildLottieSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    final lottiePath = matchedText.trim();

    return WidgetSpan(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 243, 242, 242),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(66, 122, 122, 122),
                blurRadius: 10.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Container(
            margin: const EdgeInsets.all(10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
            ),
            child: Center(
              child: Opacity(
                opacity: 0.6,
                child: Lottie.asset(
                  lottiePath,
                  height: 150.0,
                  width: 150.0,
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  static InlineSpan buildSubtleBoldSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    return TextSpan(
      text: matchedText,
      style: TextStyles.subtleBold,
    );
  }

  static InlineSpan buildVersionSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    return TextSpan(
      text: matchedText,
      style: TextStyles.version,
    );
  }

  static InlineSpan buildImageSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    final imagePath = matchedText.trim();

    return WidgetSpan(
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(66, 122, 122, 122),
                blurRadius: 10.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: Image.asset(
              imagePath,
              height: 200.0,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }

  static InlineSpan buildCheckIconSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    return const WidgetSpan(
      child: Icon(Icons.check_box_rounded, color: Colors.green, size: 14),
      alignment: PlaceholderAlignment.middle,
    );
  }

  static InlineSpan buildVideoSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    return WidgetSpan(
      alignment: PlaceholderAlignment.middle,
      child: Center(
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: const Color.fromARGB(255, 243, 242, 242),
            borderRadius: BorderRadius.circular(20.0),
            boxShadow: const [
              BoxShadow(
                color: Color.fromARGB(66, 122, 122, 122),
                blurRadius: 10.0,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Container(
                height: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20.0),
                  gradient: const LinearGradient(
                    colors: [
                      Colors.black54,
                      Colors.transparent,
                    ],
                    begin: Alignment.bottomCenter,
                    end: Alignment.topCenter,
                  ),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width - 40,
                  child: VideoPlayerWidget(videoPath: matchedText),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static InlineSpan buildContributorsSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    final parts = matchedText.split(',');
    final username = parts[0].split(':')[1].trim();
    final commits = parts[1].split(':')[1].trim();
    final additions = parts[2].split(':')[1].trim();
    final deletions = parts[3].split(':')[1].trim();
    final userImage = parts[4].split(':')[1].trim().replaceAll('\'', '');
    final githubUrl = 'https://github.com/$username';

    return WidgetSpan(
      child: GestureDetector(
        onTap: () async {
          final Uri uri = Uri.parse(githubUrl);
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $uri';
          }
        },
        child: Center(
          child: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(66, 122, 122, 122),
                  blurRadius: 10.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      'lib/playground/onboarding/assets/images/github.webp',
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(0, 0, 0, 0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: const Text(
                      'Github',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  left: 10.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(75, 0, 0, 0),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 20.0,
                          backgroundImage: AssetImage(userImage),
                          onBackgroundImageError: (_, __) {
                            // Handle error and show default image
                          },
                        ),
                        const SizedBox(width: 10.0),
                        Text(
                          '@$username',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.none,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 10.0,
                  left: 10.0,
                  right: 20.0,
                  child: Container(
                    padding: const EdgeInsets.all(10.0),
                    decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildContributorStat('Commits', commits, Colors.white),
                        _buildContributorStat('Additions', additions,
                            const Color.fromARGB(255, 102, 191, 105)),
                        _buildContributorStat('Deletions', deletions,
                            const Color.fromARGB(255, 247, 95, 84)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static Widget _buildContributorStat(String label, String value, Color color) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
          decoration: BoxDecoration(
            color: Colors.black54,
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 16.0,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 14.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  static InlineSpan buildSponsorSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    final parts = matchedText.split(',');
    final companyName = parts[0].split(':')[1].trim();
    final description = parts[1].split(':')[1].trim();
    final logo = parts[2].split(':')[1].trim().replaceAll('\'', '');
    final websiteUrl = parts[3].split(':')[1].trim();

    final Uri uri = Uri.parse(
        websiteUrl.startsWith('http') ? websiteUrl : 'https://$websiteUrl');

    return WidgetSpan(
      child: GestureDetector(
        onTap: () async {
          if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
            throw 'Could not launch $uri';
          }
        },
        child: Center(
          child: Container(
            margin:
                const EdgeInsets.symmetric(vertical: 20.0, horizontal: 10.0),
            padding: const EdgeInsets.all(10.0),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.0),
              boxShadow: const [
                BoxShadow(
                  color: Color.fromARGB(66, 122, 122, 122),
                  blurRadius: 10.0,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Opacity(
                    opacity: 0.8,
                    child: Image.asset(
                      logo,
                      height: 200.0,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  height: 200.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20.0),
                    gradient: const LinearGradient(
                      colors: [
                        Colors.black54,
                        Colors.transparent,
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),
                Positioned(
                  top: 10.0,
                  right: 10.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 4.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(0, 0, 0, 0),
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Text(
                      companyName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 30.0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16.0, vertical: 8.0),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(75, 0, 0, 0),
                      borderRadius: BorderRadius.circular(20.0),
                      boxShadow: const [
                        BoxShadow(
                          color: Colors.black45,
                          blurRadius: 8.0,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      description,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.none,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static InlineSpan buildWebSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    return InteractiveSpan.build(
      context,
      matchedText.startsWith('http') ? matchedText : 'https://$matchedText',
      matchedText,
      'lib/playground/onboarding/assets/images/web.webp',
      'Web',
      includeAtSymbol: false,
    );
  }

  static InlineSpan buildTwitterSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    return InteractiveSpan.build(
      context,
      'https://x.com/$matchedText',
      matchedText,
      'lib/playground/onboarding/assets/images/x.webp',
      'x',
      includeAtSymbol: true,
    );
  }

  static InlineSpan buildGithubSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    return InteractiveSpan.build(
      context,
      'https://github.com/$matchedText',
      matchedText,
      'lib/playground/onboarding/assets/images/github.webp',
      'Github',
      includeAtSymbol: true,
    );
  }

  static InlineSpan buildYoutubeSpan(
      BuildContext context, RegExpMatch match, String matchedText) {
    return InteractiveSpan.build(
      context,
      'https://www.youtube.com/@$matchedText',
      matchedText,
      'lib/playground/onboarding/assets/images/youtube.webp',
      'YouTube',
      includeAtSymbol: true,
    );
  }

  static WidgetSpan buildInteractiveSpan(BuildContext context, String url,
      String matchedText, String imagePath, String label,
      {bool includeAtSymbol = false}) {
    return InteractiveSpan.build(context, url, matchedText, imagePath, label,
        includeAtSymbol: includeAtSymbol);
  }
}
