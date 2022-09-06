class Rk4Solver {
  /// [function] returns `[acceleration, velocity]` and takes `[velocity, position]`.
  /// [initialState] is `[velocity, position]`.
  /// This returns `[deltaVelocity], [deltaPosition]`.
  List<double> solve({
    required List<double> Function(List<double> state) function,
    required List<double> initialState,
    required double delta,
  }) {
    final List<double> k1 = function(initialState);
    final List<double> k2 = function(initialState + k1 * delta * 0.5);
    final List<double> k3 = function(initialState + k2 * delta * 0.5);
    final List<double> k4 = function(initialState + k3 * delta);

    final List<double> newStates = <double>[];
    for (int i = 0; i < initialState.length; i++) {
      final double sum = k1[i] + 2 * k2[i] + 2 * k3[i] + k4[i];
      final double change = sum * delta / 6;

      newStates.add(initialState[i] + change);
    }

    return newStates;
  }
}

extension A on List<double> {
  // List<double> operator /(double other) {
  //   final List<double> result = <double>[];
  //   for (final double i in this) {
  //     result.add(i / other);
  //   }

  //   return result;
  // }

  List<double> operator *(double other) {
    final List<double> result = <double>[];
    for (final double i in this) {
      result.add(i * other);
    }

    return result;
  }

  List<double> operator +(double other) {
    final List<double> result = <double>[];
    for (final double i in this) {
      result.add(i + other);
    }

    return result;
  }
}
