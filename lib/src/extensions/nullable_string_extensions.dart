
extension NullableStringExtensions<T extends String?> on T {
  bool get isNullOrEmpty {
    if (this == null) {
      return true;
    }

    if (this == '') {
      return true;
    }

    return false;
  }
}
