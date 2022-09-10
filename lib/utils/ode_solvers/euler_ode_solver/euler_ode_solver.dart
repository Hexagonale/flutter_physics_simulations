import 'package:physics/physics.dart';

/// Euler integration ODE solver.
class EulerOdeSolver extends OdeSolver {
  @override
  List<ObjectState<T, R>> solve<T extends Vector, R>({
    required List<ObjectDerivative<T, R>> Function(List<ObjectState<T, R>> state) function,
    required List<ObjectState<T, R>> initialState,
    required double delta,
  }) {
    final List<ObjectDerivative<T, R>> derivatives = function(initialState);
    final List<ObjectState<T, R>> deltaState = derivatives.toState(delta);

    return initialState.sum(deltaState);
  }
}
