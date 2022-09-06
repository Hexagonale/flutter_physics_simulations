import 'package:physics/physics.dart';

/// 4th order Runge-Kutta ODE solver.
class Rk4Solver {
  /// Solves ODE differential equation using RK4 method.
  ///
  /// [function] should return list of derivatives for each of the simulation objects.
  /// [initialState] should contain initial states for each of the simulation objects.
  /// [delta] should be seconds since last simulation frame.
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
