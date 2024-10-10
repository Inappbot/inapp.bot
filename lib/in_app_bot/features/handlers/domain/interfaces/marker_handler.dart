import 'package:flutter/widgets.dart';

abstract class MarkerHandler {
  List<Widget> handle(String marker, BuildContext context, dynamic ref);
}
