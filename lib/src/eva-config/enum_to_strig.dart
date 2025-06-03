mixin EnumToStrig {
  @override
  String toString() {
    return super.toString().split('.').last;
  }
}
