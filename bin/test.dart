void main(List<String> args) {
  print(_getName('ScadaProject'));
  print(_getName('Scada-Project'));
  print(_getName('scada_project'));
  print(_getName('скада_прожект'));
}

Object _getName(String rawName) {
  return rawName
      .replaceAllMapped(RegExp("[A-Z,А-Я]"), (m) => " ${m[0]}")
      .split(RegExp("(-|_| )"))
      .where((e) => e.isNotEmpty)
      .map((e) => "${e[0].toUpperCase()}${e.substring(1)}")
      .join(" ");
}
