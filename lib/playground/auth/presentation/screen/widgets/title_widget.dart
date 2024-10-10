import 'package:flutter/material.dart';

class TitleWidget extends StatefulWidget {
  const TitleWidget({Key? key}) : super(key: key);

  @override
  TitleWidgetState createState() => TitleWidgetState();
}

class TitleWidgetState extends State<TitleWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = ColorTween(
      begin: const Color.fromARGB(255, 155, 151, 239),
      end: const Color(0xFF4c44e1),
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Welcome to the Future of',
          style: TextStyle(
            fontSize: 32.0,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            fontFamily: 'popins',
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 16),
        Container(
          width: 60,
          height: 60,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.white,
          ),
          child: Center(
            child: AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return Text(
                  'AI',
                  style: TextStyle(
                    fontSize: 36.0,
                    fontWeight: FontWeight.w700,
                    color: _colorAnimation.value,
                    fontFamily: 'popins',
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
