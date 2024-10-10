import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/presentation/providers/playground_providers.dart';

class AppBarWidget extends ConsumerWidget {
  final String title;
  final bool fromBottomNavigationBar;
  final WidgetRef ref;
  final Widget headerImage;

  const AppBarWidget({
    Key? key,
    required this.title,
    required this.fromBottomNavigationBar,
    required this.ref,
    required this.headerImage,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return SliverAppBar(
      pinned: true,
      floating: false,
      expandedHeight: 150,
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xDD020623),
          fontFamily: 'Poppins',
        ),
      ),
      flexibleSpace: headerImage,
      leading: IconButton(
        icon: fromBottomNavigationBar
            ? const Icon(Icons.close, color: Colors.black)
            : const Icon(Icons.arrow_back_ios, color: Colors.black),
        onPressed: () {
          ref.read(selectedPageIndexProvider.notifier).state = 0;
          ref.read(imageSizeProvider.notifier).state = 100;
          Navigator.pop(context);
        },
      ),
    );
  }
}
