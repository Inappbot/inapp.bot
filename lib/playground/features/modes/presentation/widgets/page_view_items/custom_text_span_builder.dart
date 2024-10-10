import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/features/modes/presentation/widgets/page_view_items/text_span_builders.dart';

class CustomTextSpanBuilder {
  static final Map<RegExp,
      InlineSpan Function(BuildContext, RegExpMatch, String)> spanBuilders = {
    RegExp(r'\*\*(.*?)\*\*'): TextSpanBuilders.buildBoldSpan,
    RegExp(r'\&\&(.*?)\&\&'): TextSpanBuilders.buildLottieSpan,
    RegExp(r'\+(.*?)\+'): TextSpanBuilders.buildSubtleBoldSpan,
    RegExp(r'\#\#(.*?)\#\#'): TextSpanBuilders.buildVersionSpan,
    RegExp(r'\@\@(.*?)\@\@'): TextSpanBuilders.buildImageSpan,
    RegExp(r'iconcheck'): TextSpanBuilders.buildCheckIconSpan,
    RegExp(r'vv(.*?)vv'): TextSpanBuilders.buildVideoSpan,
    RegExp(r'web\((.*?)\)'): TextSpanBuilders.buildWebSpan,
    RegExp(r'x\((.*?)\)'): TextSpanBuilders.buildTwitterSpan,
    RegExp(r'github\((.*?)\)'): TextSpanBuilders.buildGithubSpan,
    RegExp(r'youtube\((.*?)\)'): TextSpanBuilders.buildYoutubeSpan,
    RegExp(r'contributors\((.*?)\)'): TextSpanBuilders.buildContributorsSpan,
    RegExp(r'sponsor\((.*?)\)'): TextSpanBuilders.buildSponsorSpan,
  };

  static TextSpan build(BuildContext context, String text) {
    List<InlineSpan> spans = [];
    int lastMatchEnd = 0;

    List<RegExpMatch> allMatches = _findAllMatches(text);
    allMatches.sort((a, b) => a.start.compareTo(b.start));

    for (final match in allMatches) {
      final String beforeMatch = text.substring(lastMatchEnd, match.start);
      final String matchedText =
          match.pattern.pattern == RegExp(r'iconcheck').pattern
              ? ''
              : (match.group(1) ?? '');

      if (beforeMatch.isNotEmpty) {
        spans.add(TextSpan(text: beforeMatch));
      }

      final spanBuilder = spanBuilders[match.pattern];
      if (spanBuilder != null) {
        spans.add(spanBuilder(context, match, matchedText));
      } else {
        spans.add(TextSpan(text: matchedText));
      }

      lastMatchEnd = match.end;
    }

    if (lastMatchEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastMatchEnd)));
    }

    return TextSpan(
      style: const TextStyle(
        color: Color.fromARGB(221, 33, 33, 33),
        fontSize: 14,
        height: 1.5,
        fontFamily: 'Poppins',
      ),
      children: spans,
    );
  }

  static List<RegExpMatch> _findAllMatches(String text) {
    return spanBuilders.keys
        .expand((pattern) => pattern.allMatches(text))
        .toList();
  }
}

TextSpan buildTextSpan(BuildContext context, String text) {
  return CustomTextSpanBuilder.build(context, text);
}
