/// Iranian mobile: 11 digits starting with 09.
bool isValidIranPhone(String phone) {
  final normalized = phone.trim().replaceAll(RegExp(r'[\s-]'), '');
  return RegExp(r'^09\d{9}$').hasMatch(normalized);
}

String normalizeIranPhone(String phone) {
  var normalized = phone.trim().replaceAll(RegExp(r'[\s-]'), '');
  if (normalized.startsWith('+98')) {
    normalized = '0${normalized.substring(3)}';
  } else if (normalized.startsWith('98') && normalized.length == 12) {
    normalized = '0${normalized.substring(2)}';
  } else if (normalized.length == 10 && normalized.startsWith('9')) {
    normalized = '0$normalized';
  }
  return normalized;
}
