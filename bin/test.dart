import 'dart:io';

void main(List<String> args) {
  for (var x in Platform.environment.entries) {
    print("${x.key} => ${x.value}");
  }
}
