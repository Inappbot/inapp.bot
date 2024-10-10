import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/presentation/providers/playground_providers.dart';

Widget buildTabs(WidgetRef ref, List<Map<String, String>> modeItems,
    PageController pageController) {
  final selectedPageIndex = ref.watch(selectedPageIndexProvider);
  return ListView.builder(
    scrollDirection: Axis.horizontal,
    itemCount: modeItems.length,
    itemBuilder: (context, index) {
      final isSelected = selectedPageIndex == index;
      return GestureDetector(
        onTap: () {
          ref.read(selectedPageIndexProvider.notifier).state = index;
          pageController.jumpToPage(index);
        },
        child: buildTabItem(context, modeItems, index, isSelected),
      );
    },
  );
}

Widget buildTabItem(BuildContext context, List<Map<String, String>> modeItems,
    int index, bool isSelected) {
  return Container(
    width: MediaQuery.of(context).size.width * 0.3333333,
    padding: const EdgeInsets.symmetric(horizontal: 0),
    alignment: Alignment.center,
    color: Colors.white,
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          modeItems[index]['title'] ?? '',
          style: const TextStyle(
            fontWeight: FontWeight.w500,
            color: Color(0xFF000000),
            fontSize: 14,
            fontFamily: 'poppins',
          ),
        ),
        const SizedBox(height: 5),
        AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          height: 2,
          width: isSelected ? MediaQuery.of(context).size.width * 0.25 : 0,
          color: isSelected
              ? const Color.fromARGB(255, 41, 36, 133)
              : Colors.transparent,
        ),
      ],
    ),
  );
}
