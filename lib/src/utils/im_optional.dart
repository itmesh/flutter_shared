class ImOptional<T> {
  const ImOptional.empty()
      : item = null,
        hasValue = false;

  const ImOptional.withValue(
    T this.item,
  ) : hasValue = true;

  final T? item;
  final bool hasValue;
}
