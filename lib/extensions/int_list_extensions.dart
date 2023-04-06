extension IntListExtensions<T extends List<int>> on T {
  void sortByValue() {
    sort((int a, int b) {
      if (a > b) {
        return 1;
      }

      if (a == b) {
        return 0;
      }

      return -1;
    });
  }
}
