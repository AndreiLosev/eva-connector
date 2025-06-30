void main(List<String> args) {
  final filters = [fn1, fn2];
  final x = ['wasa', 'pety', 'igor'];

  print(x.where(fn1));
  print(x.where(fn2));
  print(x.where((e) => makeFilters(filters, e)));
}

bool fn1(String x) {
  return !x.startsWith('w');
}

bool fn2(String x) {
  return !x.startsWith('p');
}

bool makeFilters(Iterable<bool Function(String)?> filters, String arr) {
  bool res = true;
  for (var fn in filters) {
    if (fn == null) {
      continue;
    }
    res = fn(arr);

    if (!res) {
      return false;
    }
  }

  return res;
}
