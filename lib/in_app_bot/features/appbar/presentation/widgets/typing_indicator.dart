import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class TypingIndicator extends StatelessWidget {
  final bool isTyping;

  const TypingIndicator({Key? key, required this.isTyping}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: isTyping ? 30 : 10,
      height: 8,
      child: isTyping
          ? const SpinKitThreeBounce(
              color: Color(0xFF2196F3),
              size: 18.0,
            )
          : _buildIndicatorDot(),
    );
  }

  Widget _buildIndicatorDot() {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 2.0),
        width: 8.0,
        height: 8.0,
        decoration: const BoxDecoration(
          color: Colors.green,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

Widget buildTypingIndicator(BuildContext context, bool isTyping) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      TypingIndicator(isTyping: isTyping),
      Text(
        isTyping ? "Thinking..." : "assistant",
        style: TextStyle(
          color: Theme.of(context).colorScheme.onPrimary,
          fontSize: 14,
          fontWeight: FontWeight.w700,
          fontFamily: 'Poppins',
        ),
      ),
    ],
  );
}
