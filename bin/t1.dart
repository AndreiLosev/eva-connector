void main(List<String> args) {
  final name = 'xc/py/for_py_macro/my_macro-3.py';
  final d = 'xc/py';
  print(name.replaceFirst(RegExp('^$d/'), ''));
}
