import 'package:flutter/material.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/presentation/widgets/form_report_widget.dart';
import 'package:in_app_bot/in_app_bot/features/handlers/domain/interfaces/marker_handler.dart';

class FormHandler implements MarkerHandler {
  @override
  List<Widget> handle(String marker, BuildContext context, dynamic ref) {
    return [const FormReportWidget()];
  }
}
