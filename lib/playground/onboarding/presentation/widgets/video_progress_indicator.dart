import 'dart:math';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class VideoProgressIndicatorCircle extends CustomPainter {
  final double progress;
  final Duration totalDuration;

  VideoProgressIndicatorCircle({
    required this.progress,
    required this.totalDuration,
  });

  static final Paint _backgroundPaint = Paint()
    ..color = Colors.grey.withAlpha(50)
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  static final Paint _progressPaint = Paint()
    ..color = const Color(0xFF2196F3)
    ..strokeWidth = 3
    ..style = PaintingStyle.stroke;

  static final Paint _knobPaint = Paint()
    ..color = const Color(0xFF2196F3)
    ..style = PaintingStyle.fill;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    _drawBackgroundCircle(canvas, center, radius);
    _drawProgressArc(canvas, center, radius);
    _drawKnob(canvas, center, radius);
    _drawRemainingTimeText(canvas, center, radius);
  }

  void _drawBackgroundCircle(Canvas canvas, Offset center, double radius) {
    canvas.drawCircle(center, radius, _backgroundPaint);
  }

  void _drawProgressArc(Canvas canvas, Offset center, double radius) {
    final angle = 2 * pi * progress;
    canvas.drawArc(Rect.fromCircle(center: center, radius: radius), -pi / 2,
        angle, false, _progressPaint);
  }

  void _drawKnob(Canvas canvas, Offset center, double radius) {
    final angle = 2 * pi * progress;
    final knobPosition = Offset(
      center.dx + radius * cos(angle - pi / 2),
      center.dy + radius * sin(angle - pi / 2),
    );
    canvas.drawCircle(knobPosition, 10, _knobPaint);
  }

  void _drawRemainingTimeText(Canvas canvas, Offset center, double radius) {
    final angle = 2 * pi * progress;
    final knobPosition = Offset(
      center.dx + radius * cos(angle - pi / 2),
      center.dy + radius * sin(angle - pi / 2),
    );
    final remainingSeconds = (totalDuration.inSeconds * (1 - progress)).round();
    final text = '$remainingSeconds';

    final paragraphBuilder = ui.ParagraphBuilder(ui.ParagraphStyle(
      textAlign: TextAlign.center,
      fontWeight: FontWeight.bold,
      fontSize: 10,
    ))
      ..pushStyle(ui.TextStyle(color: Colors.white))
      ..addText(text);

    final paragraph = paragraphBuilder.build()
      ..layout(const ui.ParagraphConstraints(width: 30));
    canvas.drawParagraph(paragraph, knobPosition - const Offset(15, 7));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return oldDelegate is! VideoProgressIndicatorCircle ||
        oldDelegate.progress != progress ||
        oldDelegate.totalDuration != totalDuration;
  }
}
