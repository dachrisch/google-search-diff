mixin UuidMixin {
  late final String _id;

  @override
  String toString() {
    return _id;
  }

  @override
  int get hashCode => _id.hashCode;

  @override
  bool operator ==(Object other) =>
      other.runtimeType == runtimeType && _id == (other as UuidMixin)._id;

  void initId(String id) => _id = id;
}
