import 'dart:io';

class WordCounter {
  int countWords(String filePath) {
    final file = File(filePath);
    final content = file.readAsStringSync();
    final words = content.split(RegExp(r'\s+'));
    return words.length;
  }
}
