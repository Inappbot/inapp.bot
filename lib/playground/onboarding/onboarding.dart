import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/playground/onboarding/presentation/controllers/onboarding_screen_controller.dart';
import 'package:in_app_bot/playground/onboarding/presentation/providers/providers_onboarding.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/continue_button_widget.dart';
import 'package:in_app_bot/playground/onboarding/presentation/widgets/page_view_widget.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen>
    with TickerProviderStateMixin, WidgetsBindingObserver {
  late final OnboardingScreenController _controller;

  @override
  void initState() {
    super.initState();
    _controller = OnboardingScreenController(context, ref, this);
    _controller.onNeedUpdate = () {
      setState(() {});
    };
    _controller.setupInitialDependencies();
    WidgetsBinding.instance.addObserver(this);
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void didChangeMetrics() {
    _controller.handleKeyboardVisibility();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            PageViewWidget(
              pageController: _controller.pageController,
              formKey: _controller.formKey,
              ref: ref,
              mounted: mounted,
              animationControllerService:
                  _controller.animationControllerService,
              formOpacityTimer: _controller.formOpacityTimer,
            ),
            _continueButtonWidget(),
          ],
        ),
      ),
    );
  }

  Widget _continueButtonWidget() {
    final currentPage = ref.watch(UIState.currentPage);
    return ContinueButtonWidget(
      currentPage: currentPage,
      pageController: _controller.pageController,
      formKey: _controller.formKey,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    super.dispose();
  }
}
