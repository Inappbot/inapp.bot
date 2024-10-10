import 'package:flutter/material.dart';

class AnimatedLogoCellphone extends StatelessWidget {
  final double imageSize;
  final Animation<double> sizeAnimation;

  const AnimatedLogoCellphone({
    Key? key,
    required this.imageSize,
    required this.sizeAnimation,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Image.asset(
          'lib/playground/onboarding/assets/images/cellphone.webp',
          fit: BoxFit.cover,
        ),
        AnimatedBuilder(
          animation: sizeAnimation,
          builder: (_, __) => Container(
            width: sizeAnimation.value,
            height: sizeAnimation.value,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(8)),
              image: DecorationImage(
                image: AssetImage(
                    'lib/playground/onboarding/assets/images/inappbot_logo_new.webp'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

Widget buildModeContainer(
    String imageUrl, double imageSize, Animation<double> sizeAnimation) {
  const String cellphoneImagePath =
      'lib/playground/onboarding/assets/images/cellphone.webp';
  return Column(
    mainAxisAlignment: MainAxisAlignment.end,
    children: [
      Flexible(
        child: Hero(
          tag: imageUrl,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 100),
            height: imageSize,
            width: imageSize,
            child: imageUrl == cellphoneImagePath
                ? AnimatedLogoCellphone(
                    imageSize: sizeAnimation.value,
                    sizeAnimation: sizeAnimation,
                  )
                : Image.asset(imageUrl, fit: BoxFit.contain),
          ),
        ),
      ),
    ],
  );
}
