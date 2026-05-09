class ExpireItem {
  String item;
  double time;

  ExpireItem(this.item, this.time);

  String toConfig() {
    return "$item: $time";
  }

  void loadFromString(String config) {
    final [itemStr, timeStr] = config.split(': ');
    item = itemStr;
    time = double.parse(timeStr);
  }
}

