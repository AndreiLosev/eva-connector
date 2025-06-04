abstract interface class Serializable {
  Map<String, dynamic> toMap();
  void loadFromMap(Map map);
}
