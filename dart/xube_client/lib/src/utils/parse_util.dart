class ParseUtil {
  static int toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value) ?? 0;
  }

  static intToString(dynamic value) {
    if (value is String) return value;

    return value.toString();
  }
}
