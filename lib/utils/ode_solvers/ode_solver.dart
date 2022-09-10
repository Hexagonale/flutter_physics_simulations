import 'package:physics/physics.dart';

abstract class OdeSolver {
  /// Solves ODE differential equation for the given [initialState] and [delta] time.
  ///
  /// [function] should return list of derivatives for each of the simulation objects.
  /// [initialState] should contain initial states for each of the simulation objects.
  /// [delta] should be seconds since last simulation iteration.
  ///
  /// Returns list of object states after this iteration.
  /// !IMPORTANT does NOT return delta state.
  List<ObjectState<T, R>> solve<T extends Vector, R>({
    required List<ObjectDerivative<T, R>> Function(List<ObjectState<T, R>> state) function,
    required List<ObjectState<T, R>> initialState,
    required double delta,
  });
}
