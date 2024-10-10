double parseDouble(dynamic value) {
  if (value is String) {
    return double.tryParse(value) ?? 0.0;
  } else if (value is int) {
    return value.toDouble();
  } else if (value is double) {
    return value;
  }
  return 0.0;
}

int parseInt(dynamic value) {
  if (value is String) {
    return int.tryParse(value) ?? 0;
  } else if (value is double) {
    return value.toInt();
  } else if (value is int) {
    return value;
  }
  return 0;
}
