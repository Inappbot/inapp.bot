import 'package:flutter/material.dart';

class ImageWidget extends StatelessWidget {
  final bool showImage;

  const ImageWidget({Key? key, required this.showImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double imageSize = MediaQuery.of(context).size.width * 0.8;

    return showImage
        ? Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: imageSize,
              height: imageSize,
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(
                      'lib/playground/onboarding/assets/images/phones.webp'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          )
        : Container();
  }
}
