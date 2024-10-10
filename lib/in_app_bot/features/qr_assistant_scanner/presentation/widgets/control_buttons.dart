import 'package:flutter/material.dart';

class ControlButtons extends StatelessWidget {
  final bool isFlashOn;
  final bool hasScanned;
  final bool isFlashButtonEnabled;
  final VoidCallback onFlashPressed;
  final VoidCallback onFlipPressed;

  const ControlButtons({
    Key? key,
    required this.isFlashOn,
    required this.hasScanned,
    required this.isFlashButtonEnabled,
    required this.onFlashPressed,
    required this.onFlipPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        _buildControlButton(
          context: context,
          icon: isFlashOn ? Icons.flash_on : Icons.flash_off,
          label: 'Flash',
          onPressed:
              (hasScanned || !isFlashButtonEnabled) ? null : onFlashPressed,
        ),
        const SizedBox(width: 40),
        _buildControlButton(
          context: context,
          icon: Icons.flip_camera_ios,
          label: 'Flip',
          onPressed: hasScanned ? null : onFlipPressed,
        ),
      ],
    );
  }

  Widget _buildControlButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback? onPressed,
  }) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            color: Color.fromARGB(255, 255, 255, 255),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: Icon(icon,
                color: const Color.fromARGB(255, 42, 42, 42), size: 28),
            onPressed: onPressed,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: Theme.of(context)
              .textTheme
              .bodySmall
              ?.copyWith(color: Colors.white70),
        ),
      ],
    );
  }
}
