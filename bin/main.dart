import 'test.dart';

void main(List<String> arguments) {
  if (arguments.isEmpty) {
    print('Please provide a file path as an argument.');
    return;
  }

  final wordCounter = WordCounter();
  final wordCount = wordCounter.countWords(arguments[0]);
  print('Word count: $wordCount');
}
