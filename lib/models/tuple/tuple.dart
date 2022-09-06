class Tuple<T> {
  Tuple(this.a, this.b);

  final T a;

  final T b;

  T operator [](int index) {
    switch (index) {
      case 0:
        return a;

      case 1:
        return b;
    }

    throw RangeError('Index $index is greater than 1');
  }
}
