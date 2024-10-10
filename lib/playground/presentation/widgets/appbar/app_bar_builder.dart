import 'package:flutter/material.dart';
import 'package:in_app_bot/playground/presentation/widgets/appbar/app_bar_title_text.dart';

class AnimatedAppBar extends StatefulWidget implements PreferredSizeWidget {
  const AnimatedAppBar({super.key});

  @override
  AnimatedAppBarState createState() => AnimatedAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(80.0);
}

class AnimatedAppBarState extends State<AnimatedAppBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false,
      backgroundColor: Colors.white,
      title: _buildAppBarTitle(),
      elevation: 0,
      centerTitle: true,
      toolbarHeight: 70,
      shadowColor: Colors.grey.withOpacity(0.5),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(10.0),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return _buildAppBarBottomLine(context);
          },
        ),
      ),
    );
  }

  Widget _buildAppBarTitle() {
    return const SizedBox(
      height: 70,
      child: AppBarTitleText(),
    );
  }

  Widget _buildAppBarBottomLine(BuildContext context) {
    return Container(
      height: 8.0,
      width: MediaQuery.of(context).size.width,
      decoration: const BoxDecoration(),
      child: CustomPaint(
        painter: GradientPainter(_controller.value),
      ),
    );
  }
}

class GradientPainter extends CustomPainter {
  final double animationValue;
  GradientPainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final gradient = LinearGradient(
      begin: Alignment.centerLeft,
      end: Alignment.centerRight,
      stops: [animationValue - 0.2, animationValue, animationValue + 0.2],
      colors: const [
        Color(0xFF3a1c71),
        Color.fromARGB(255, 126, 98, 177),
        Color.fromARGB(255, 69, 48, 108),
      ],
    );
    final paint = Paint()..shader = gradient.createShader(rect);
    canvas.drawRect(rect, paint);

    // Calculate opacity based on the animation value, making it smoother
    final opacity = (1 - (animationValue - 0.5).abs() * 4).clamp(0.0, 1.0);

    // Draw "love flutter" text
    final textPainter = TextPainter(
      text: TextSpan(
        text: 'inapp.bot',
        style: TextStyle(
          color: Colors.white.withOpacity(opacity),
          fontSize: 7,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(minWidth: 0, maxWidth: size.width);

    final offset = Offset((size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2);
    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
