extension ObjectExtensions<T extends Object> on T {
  O cast<O>() {
    return this as O;
  }

  O? safeCast<O>() {
    try {
      return cast();
    } catch (e) {
      return null;
    }
  }
}
