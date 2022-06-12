extension StreamExtension on Stream {
  Future<T?> safeFirst<T>() async {
    try {
      return await first as T;
    } catch (e) {
      return null;
    }
  }
}
