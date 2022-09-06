import 'package:physics/physics.dart';

class Rk4Solver {
  /// [function] returns `[acceleration, velocity]` and takes `[velocity, position]`.
  /// [initialState] is `[velocity, position]`.
  /// This returns `[deltaVelocity], [deltaPosition]`.
  List<ObjectState<T>> solve<T extends Vector>({
    required List<ObjectDerivative<T>> Function(List<ObjectState<T>> state) function,
    required List<ObjectState<T>> initialState,
    required double delta,
  }) {
    final List<ObjectDerivative<T>> k1 = function(initialState);
    final List<ObjectDerivative<T>> k2 = function(initialState + k1.toState(delta * 0.5));
    final List<ObjectDerivative<T>> k3 = function(initialState + k2.toState(delta * 0.5));
    final List<ObjectDerivative<T>> k4 = function(initialState + k3.toState(delta));

    final List<ObjectState<T>> newStates = <ObjectState<T>>[];
    for (int i = 0; i < initialState.length; i++) {
      final ObjectDerivative<T> sum = k1[i] + k2[i] * 2 + k3[i] * 2 + k4[i];
      final ObjectState<T> change = sum.toState(delta / 6);

      newStates.add(initialState[i] + change);
    }

    return newStates;
  }
}

extension A<T extends Vector> on List<ObjectDerivative<T>> {
  List<ObjectDerivative<T>> operator *(double other) {
    final List<ObjectDerivative<T>> result = <ObjectDerivative<T>>[];

    for (final ObjectDerivative<T> i in this) {
      result.add(i * other);
    }

    return result;
  }

  List<ObjectState<T>> toState(double delta) {
    final List<ObjectState<T>> result = <ObjectState<T>>[];

    for (final ObjectDerivative<T> i in this) {
      result.add(i.toState(delta));
    }

    return result;
  }
}
