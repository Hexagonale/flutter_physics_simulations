import 'package:physics/physics.dart';

/// 4th order Runge-Kutta ODE solver.
class Rk4Solver {
  /// Solves ODE differential equation using RK4 method.
  ///
  /// [function] should return list of derivatives for each of the simulation objects.
  /// [initialState] should contain initial states for each of the simulation objects.
  /// [delta] should be seconds since last simulation frame.
  List<ObjectState<T, R>> solve<T extends Vector, R>({
    required List<ObjectDerivative<T, R>> Function(List<ObjectState<T, R>> state) function,
    required List<ObjectState<T, R>> initialState,
    required double delta,
  }) {
    final List<ObjectDerivative<T, R>> k1 = function(initialState);
    final List<ObjectDerivative<T, R>> k2 = function(initialState + k1.toState(delta * 0.5));
    final List<ObjectDerivative<T, R>> k3 = function(initialState + k2.toState(delta * 0.5));
    final List<ObjectDerivative<T, R>> k4 = function(initialState + k3.toState(delta));

    final List<ObjectState<T, R>> newStates = <ObjectState<T, R>>[];
    for (int i = 0; i < initialState.length; i++) {
      final ObjectDerivative<T, R> sum = k1[i] + k2[i] * 2 + k3[i] * 2 + k4[i];
      final ObjectState<T, R> change = sum.toState(delta / 6);

      newStates.add(initialState[i] + change);
    }

    return newStates;
  }
}
