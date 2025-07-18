void main(List<String> args) {
  <int>[].fold(0, (a, b) => a + b);
  int x1 = 1;
  int? x2 = 2;
  double y1 = 1.1;
  double? y2 = 2.1;

  test1(x1);
  test1(x2);
  test1(y1);
  test1(y2);
  test1<int?>(null);
}

void test1<T>(T x) {
  switch (T.toString()) {
    case 'int' || 'int?':
      print('print int: $T');
    case 'double' || 'double?':
      print('print double $T');
    default:
      print('other: $T');
  }
}
