import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class CustomProgressDialog extends StatelessWidget {
  final AnimationController? controller;
  final ValueNotifier<String> textNotifier;
  final String animationPath;
  final ValueNotifier<bool> showProgressNotifier;

  const CustomProgressDialog({
    super.key,
    this.controller,
    required this.textNotifier,
    required this.animationPath,
    required this.showProgressNotifier,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 200,
              height: 200,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnimatedBuilder(
                    animation: controller ?? const AlwaysStoppedAnimation(0),
                    builder: (context, child) {
                      final showProgress = showProgressNotifier.value &&
                          (controller?.value ?? 0) == 0;
                      return showProgress
                          ? const SizedBox(
                              width: 200,
                              height: 200,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                    Color(0xCA2195F3)),
                              ),
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: Lottie.asset(
                      animationPath,
                      controller: controller,
                      repeat: false,
                      fit: BoxFit.contain,
                      onLoaded: (composition) {
                        controller?.duration = composition.duration;
                      },
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder<String>(
              valueListenable: textNotifier,
              builder: (context, text, _) {
                return Text(
                  text,
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
