abstract interface class HasFiles {
  Map<String, String> getFiles();

  void putFile(String name, String content);

  String basePath();
}
