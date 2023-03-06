class ParseUtil {
  static int toInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value) ?? 0;
  }
}
