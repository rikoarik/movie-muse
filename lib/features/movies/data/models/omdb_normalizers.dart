String? normalizeOmdbText(Object? raw) {
  if (raw is! String) {
    return null;
  }
  final trimmed = raw.trim();
  if (trimmed.isEmpty || trimmed.toUpperCase() == 'N/A') {
    return null;
  }
  return trimmed;
}

String? normalizeOmdbPoster(Object? raw) {
  final text = normalizeOmdbText(raw);
  if (text == null) {
    return null;
  }
  final uri = Uri.tryParse(text);
  if (uri == null ||
      !uri.hasScheme ||
      (uri.scheme != 'https' && uri.scheme != 'http')) {
    return null;
  }
  return text;
}
