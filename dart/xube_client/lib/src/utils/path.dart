String substitutePathParameters(
    Map<String, String> pathParameters, String path) {
  for (final key in pathParameters.keys) {
    path = path.replaceAll('{$key}', pathParameters[key]!);
  }
  return path;
}
