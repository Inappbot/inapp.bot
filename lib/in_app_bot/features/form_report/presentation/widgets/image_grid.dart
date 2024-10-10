import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:in_app_bot/in_app_bot/features/form_report/presentation/providers/selected_images_provider.dart';

class ImageGrid extends ConsumerWidget {
  final String formId;

  const ImageGrid({Key? key, required this.formId}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedImages =
        ref.watch(selectedImagesProvider(formId))[formId] ?? [];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: selectedImages.asMap().entries.map((entry) {
        final index = entry.key;
        final file = entry.value;
        return Stack(
          alignment: Alignment.topRight,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: 100,
                height: 150,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.0),
                  image: DecorationImage(
                    image: FileImage(file),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
            Positioned(
              top: 4,
              right: 4,
              child: _buildRemoveImageButton(index, formId, ref),
            ),
          ],
        );
      }).toList(),
    );
  }

  Widget _buildRemoveImageButton(int index, String formId, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        width: 30,
        height: 30,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.7),
          shape: BoxShape.circle,
        ),
        child: IconButton(
          padding: EdgeInsets.zero,
          icon:
              Icon(Icons.close, size: 18, color: Colors.black.withOpacity(0.7)),
          onPressed: () {
            ref
                .read(selectedImagesProvider(formId).notifier)
                .removeImage(formId, index);
          },
        ),
      ),
    );
  }
}
