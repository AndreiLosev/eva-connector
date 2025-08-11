void main() {
  final x = [1, 2, 3, 4, 5];
  final y = x.cast<int?>().firstWhere((x) => x == 13, orElse: () => null);

  print(y);
}
