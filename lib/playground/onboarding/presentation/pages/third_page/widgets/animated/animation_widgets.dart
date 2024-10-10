import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

Widget currentLottieWidget(String path, double size, String title) => Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(title,
              style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 54, 54, 54),
                  fontFamily: 'poppins')),
          SizedBox(
              width: size,
              height: size,
              child: Lottie.asset(path, fit: BoxFit.contain)),
        ],
      ),
    );

Widget fixedLottieWidget(double size) => Positioned(
      top: 25,
      left: 0,
      right: 0,
      child: Align(
          alignment: Alignment.topCenter,
          child: SizedBox(
              width: size,
              height: size,
              child: Lottie.asset(
                  'lib/playground/onboarding/assets/animations/fixed.json',
                  fit: BoxFit.contain))),
    );
