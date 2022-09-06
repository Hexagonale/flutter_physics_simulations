extension StreamExtension<T> on Stream<T> {
  Future<T?> safeFirst() async {
    try {
      return await first;
    } catch (e) {
      return null;
    }
  }
}
