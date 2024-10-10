import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/features/modes/presentation/widgets/page_view_items/custom_text_span_builder.dart';
import 'package:in_app_bot/playground/presentation/providers/playground_providers.dart';

Widget buildPageView(WidgetRef ref, List<Map<String, String>> modeItems,
    PageController pageController) {
  return PageView.builder(
    controller: pageController,
    onPageChanged: (index) {
      ref.read(selectedPageIndexProvider.notifier).state = index;
    },
    itemCount: modeItems.length,
    itemBuilder: (context, index) {
      return buildPageViewItem(context, modeItems, index);
    },
  );
}

Widget buildPageViewItem(
    BuildContext context, List<Map<String, String>> modeItems, int index) {
  return Padding(
    padding: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 0),
    child: Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20), topRight: Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: RichText(
                  text: buildTextSpan(
                      context,
                      modeItems[index]['description'] ??
                          'Description not available'),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
