import 'package:flutter/material.dart';

class ScannerAppBar extends StatelessWidget {
  final bool isBackButtonEnabled;
  final VoidCallback onBackPressed;

  const ScannerAppBar({
    Key? key,
    required this.isBackButtonEnabled,
    required this.onBackPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: Icon(
              Icons.arrow_back_ios,
              color: isBackButtonEnabled
                  ? Colors.white
                  : const Color.fromARGB(255, 108, 108, 108),
            ),
            onPressed: isBackButtonEnabled ? onBackPressed : null,
          ),
          Text(
            'AI Scanner',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(color: Colors.white),
          ),
          const SizedBox(width: 48),
        ],
      ),
    );
  }
}
