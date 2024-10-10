import 'package:flutter/material.dart';

class ReplayButton extends StatelessWidget {
  final double size;
  final VoidCallback onPressed;

  const ReplayButton({
    required this.size,
    required this.onPressed,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        border: Border.all(
            color: const Color.fromARGB(255, 216, 216, 216), width: 3),
        shape: BoxShape.circle,
        color: const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
        boxShadow: [
          BoxShadow(
            color: const Color.fromARGB(255, 237, 237, 237).withOpacity(0.8),
            spreadRadius: -2,
            blurRadius: 10,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: IconButton(
        icon: const Icon(Icons.replay, color: Color(0xFF2196F3), size: 50),
        onPressed: onPressed,
      ),
    );
  }
}
