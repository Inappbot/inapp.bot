import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String labelText;
  final int maxLines;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;

  const CustomTextField({
    Key? key,
    required this.controller,
    required this.labelText,
    this.maxLines = 1,
    required this.validator,
    required this.onSaved,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Color(0xFF3C3C3C)),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        fillColor: Colors.white,
        filled: true,
      ),
      validator: validator,
      onSaved: onSaved,
    );
  }
}
