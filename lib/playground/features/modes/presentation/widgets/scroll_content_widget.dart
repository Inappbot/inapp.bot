import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/features/modes/presentation/delegates/sliver_app_bar_delegate.dart';
import 'package:in_app_bot/playground/features/modes/presentation/widgets/mode_container_widget.dart';
import 'package:in_app_bot/playground/features/modes/presentation/widgets/navigation/custom_tab_view.dart';
import 'package:in_app_bot/playground/features/modes/presentation/widgets/page_view_items/page_view_widget.dart';
import 'package:in_app_bot/playground/features/modes/presentation/widgets/top_appbar_widget.dart';
import 'package:in_app_bot/playground/presentation/widgets/no_glow_behavior.dart';

class ScrollContent extends ConsumerWidget {
  final String title;
  final String imageUrl;
  final bool fromFloatingActionButton;
  final Animation<double> imageSizeAnimation;
  final List<Map<String, String>> modeItems;
  final PageController pageController;
  final ScrollController scrollController;
  final double imageSize;
  final bool fromBottomNavigationBar;

  const ScrollContent({
    Key? key,
    required this.title,
    required this.imageUrl,
    required this.fromFloatingActionButton,
    required this.imageSizeAnimation,
    required this.modeItems,
    required this.pageController,
    required this.scrollController,
    required this.imageSize,
    required this.fromBottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ScrollConfiguration(
      behavior: NoGlowBehavior(),
      child: NestedScrollView(
        controller: scrollController,
        headerSliverBuilder: (ctx, _) {
          return <Widget>[
            AppBarWidget(
              title: title,
              fromBottomNavigationBar: fromBottomNavigationBar,
              ref: ref,
              headerImage: FlexibleSpaceBar(
                background: buildModeContainer(
                  fromFloatingActionButton
                      ? 'lib/playground/onboarding/assets/images/cellphone.webp'
                      : imageUrl,
                  imageSize,
                  imageSizeAnimation,
                ),
              ),
            ),
            SliverPersistentHeader(
              delegate: SliverAppBarDelegate(
                minHeight: 50,
                maxHeight: 50,
                child: buildTabs(ref, modeItems, pageController),
              ),
              pinned: true,
            ),
          ];
        },
        body: buildPageView(ref, modeItems, pageController),
      ),
    );
  }
}
