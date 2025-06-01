abstract interface class Serializable {
  Map<String, dynamic> toMap();
  void loadFromMap(Map<String, dynamic> map);
}
