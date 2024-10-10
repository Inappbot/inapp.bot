import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/domain/entities/report.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/infrastructure/services/firestore_service.dart';

class SaveReportUseCase {
  final ReportService _reportService;

  SaveReportUseCase(this._reportService);

  Future<void> execute(Report report) async {
    final reportReference =
        await _reportService.saveReport(report.email, report.description);
    for (var image in report.images) {
      final imageUrl = await _reportService.uploadImage(image);
      await reportReference.collection('images').add({
        'url': imageUrl,
        'name': image.path.split('/').last,
      });
    }
  }
}

final saveReportUseCaseProvider = Provider((ref) => SaveReportUseCase(
      ref.watch(reportServiceProvider),
    ));
