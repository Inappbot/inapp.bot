import 'dart:io';

class Report {
  final String email;
  final String description;
  final List<File> images;

  Report(
      {required this.email, required this.description, required this.images});
}
