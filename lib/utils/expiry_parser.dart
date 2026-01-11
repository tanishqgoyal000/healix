class ExpiryParser {
  static final keywords = [
    'exp', 'expiry', 'expires', 'use by', 'best before'
  ];

  static final dateRegex = RegExp(
    r'(\d{2}[\/\-]\d{2}[\/\-]\d{2,4}|\d{4}[\/\-]\d{2}|\w{3}\s?\d{4})',
    caseSensitive: false,
  );

  static String? extract(String text) {
    final lower = text.toLowerCase();
    if (!keywords.any(lower.contains)) return null;

    final match = dateRegex.firstMatch(text);
    return match?.group(0);
  }
}
