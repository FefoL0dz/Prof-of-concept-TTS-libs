Uri? parseEnvUri(String key) {
  final value = String.fromEnvironment(key);
  if (value.isEmpty) return null;
  return Uri.tryParse(value);
}
