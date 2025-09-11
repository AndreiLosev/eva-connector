void main() async {
  test1();
  print('the end');
}

void test1() {
  try {
    print('try');
    return;
  } finally {
    print('finally');
  }
}
