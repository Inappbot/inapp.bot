import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/domain/interfaces/marker_handler.dart';

String? extractPromoCode(String message) {
  final pattern = RegExp(r'\[promo\]\w+');
  return pattern.firstMatch(message)?.group(0)?.replaceFirst('[promo]', '');
}

void showCopiedOverlay(BuildContext context) {
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => const Center(
      child: Material(
        color: Colors.transparent,
        child: CopiedToast(),
      ),
    ),
  );

  overlay.insert(overlayEntry);
  Future.delayed(const Duration(seconds: 2), overlayEntry.remove);
}

class CopiedToast extends StatelessWidget {
  const CopiedToast({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
      decoration: ToastDecoration.boxDecoration,
      child: const ToastContent(),
    );
  }
}

class ToastDecoration {
  // Esta es ahora una propiedad estática no constante.
  static final BoxDecoration boxDecoration = BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(10.0),
    border: Border.all(color: const Color.fromARGB(31, 0, 0, 0)),
    boxShadow: const [
      BoxShadow(
        color: Color.fromARGB(31, 0, 0, 0),
        blurRadius: 4,
        spreadRadius: 1,
      ),
    ],
  );
}

class ToastContent extends StatelessWidget {
  const ToastContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text("Copied", style: TextStyleConstants.copiedTextStyle),
        SizedBox(width: 8.0),
        Icon(Icons.check_circle, color: Colors.green),
      ],
    );
  }
}

class TextStyleConstants {
  static const TextStyle copiedTextStyle = TextStyle(
    color: Colors.black,
    fontSize: 16.0,
    fontWeight: FontWeight.bold,
  );
}

class PromoCodeHandler implements MarkerHandler {
  @override
  List<Widget> handle(String marker, BuildContext context, dynamic ref) {
    final promoCode = extractPromoCode(marker);
    if (promoCode == null) {
      return [];
    }
    return [
      Row(
        children: [
          Text(
            promoCode,
            style: const TextStyle(
              color: Color(0xFF2196F3),
              fontSize: 14.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.copy, color: Color(0xFF2196F3)),
            onPressed: () {
              Clipboard.setData(ClipboardData(text: promoCode));
              showCopiedOverlay(context);
            },
          ),
        ],
      ),
    ];
  }
}
