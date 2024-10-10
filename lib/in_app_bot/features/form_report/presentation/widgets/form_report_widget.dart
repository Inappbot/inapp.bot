import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/domain/entities/report.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/domain/use_cases/pick_images_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/domain/use_cases/save_report_use_case.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/presentation/providers/form_report_provider.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/presentation/providers/selected_images_provider.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/presentation/widgets/custom_progress_dialog.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/presentation/widgets/custom_text_field.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/presentation/widgets/image_grid.dart';

class FormReportWidget extends ConsumerStatefulWidget {
  const FormReportWidget({Key? key}) : super(key: key);

  @override
  ConsumerState<FormReportWidget> createState() => _MyFormWidgetState();
}

class _MyFormWidgetState extends ConsumerState<FormReportWidget>
    with SingleTickerProviderStateMixin {
  final _emailController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  late final AnimationController _controller;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _emailController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _saveReport() async {
    if (!_formKey.currentState!.validate()) return;

    _formKey.currentState!.save();
    final textNotifier = ValueNotifier("Sending...");
    final showProgressNotifier = ValueNotifier(true);

    _showLoadingDialog(textNotifier, showProgressNotifier);

    try {
      final saveReportUseCase = ref.read(saveReportUseCaseProvider);
      await saveReportUseCase.execute(
        Report(
          email: ref.read(myFormProvider).email,
          description: ref.read(myFormProvider).description,
          images: _getSelectedImages(),
        ),
      );

      _updateLoadingDialogSuccess(textNotifier, showProgressNotifier);
      await _closeDialogAfterDelay();
      _clearFormState();
    } catch (e) {
      _handleError(e);
    }
  }

  void _showLoadingDialog(ValueNotifier<String> textNotifier,
      ValueNotifier<bool> showProgressNotifier) {
    _controller.reset();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CustomProgressDialog(
        controller: _controller,
        textNotifier: textNotifier,
        animationPath: 'assets/animations/animation_send_plane.json',
        showProgressNotifier: showProgressNotifier,
      ),
    );
  }

  void _updateLoadingDialogSuccess(ValueNotifier<String> textNotifier,
      ValueNotifier<bool> showProgressNotifier) {
    _controller.forward();
    textNotifier.value = "Sent";
    showProgressNotifier.value = false;
  }

  Future<void> _closeDialogAfterDelay() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) Navigator.of(context).pop();
  }

  void _handleError(dynamic e) {
    log('Error saving report: $e');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Error: $e')),
    );
  }

  void _clearFormState() {
    ref.read(myFormProvider.notifier).updateFormId();

    final newFormId = ref.read(myFormProvider).formId;

    ref.read(myFormProvider.notifier)
      ..updateEmail("")
      ..updateDescription("");
    _emailController.clear();
    _descriptionController.clear();

    ref.read(selectedImagesProvider(newFormId).notifier).clearImages(newFormId);

    setState(() {});
  }

  List<File> _getSelectedImages() {
    final formId = ref.read(myFormProvider).formId;
    return ref.read(selectedImagesProvider(formId))[formId] ?? [];
  }

  Future<void> _pickImages() async {
    setState(() => _isLoading = true);
    try {
      final pickImagesUseCase = ref.read(pickImagesUseCaseProvider);
      final selectedFiles = await pickImagesUseCase.execute();
      if (selectedFiles != null) {
        final formId = ref.read(myFormProvider).formId;
        ref
            .read(selectedImagesProvider(formId).notifier)
            .addImages(formId, selectedFiles);
      }
    } catch (e) {
      log('Error picking files: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final formId = ref.watch(myFormProvider).formId;

    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                "Report a Problem",
                style: TextStyle(
                  fontSize: 24.0,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF3C3C3C),
                ),
              ),
              const SizedBox(height: 24),
              CustomTextField(
                controller: _emailController,
                labelText: 'Email',
                validator: (value) {
                  if (value == null || value.isEmpty || !value.contains('@')) {
                    return 'Please enter a valid email';
                  }
                  return null;
                },
                onSaved: (value) =>
                    ref.read(myFormProvider).email = value ?? '',
              ),
              const SizedBox(height: 16),
              CustomTextField(
                controller: _descriptionController,
                labelText: 'Problem Description',
                maxLines: 5,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a description';
                  }
                  return null;
                },
                onSaved: (value) =>
                    ref.read(myFormProvider).description = value ?? '',
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _pickImages,
                    style: _buttonStyle(),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Icon(Icons.add_a_photo, color: Colors.white),
                  ),
                  ElevatedButton(
                    onPressed: _saveReport,
                    style: _buttonStyle(),
                    child: const Text('Submit Report',
                        style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ImageGrid(formId: formId),
            ],
          ),
        ),
      ),
    );
  }

  ButtonStyle _buttonStyle() {
    return ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF3C3C3C),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    );
  }
}
