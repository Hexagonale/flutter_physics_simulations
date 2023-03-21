import 'package:physics/physics.dart';

/// Flexible Runge-Kutta ODE solver.
class RkOdeSolver extends OdeSolver {
  const RkOdeSolver({
    required this.stepsCoefficients,
    required this.kCoefficients,
  });

  final List<List<double>> stepsCoefficients;
  final List<double> kCoefficients;

  @override
  List<ObjectState<T, R>> solve<T extends Vector, R>({
    required List<ObjectDerivative<T, R>> Function(List<ObjectState<T, R>> state) function,
    required List<ObjectState<T, R>> initialState,
    required double delta,
  }) {
    final List<List<ObjectDerivative<T, R>>> listOfK = <List<ObjectDerivative<T, R>>>[
      function(initialState),
    ];

    final List<ObjectDerivative<T, R>> sum = listOfK[0] * kCoefficients[0];
    for (int step = 0; step < stepsCoefficients.length; step++) {
      final List<ObjectState<T, R>> y = _getYForStep(
        step: step,
        delta: delta,
        initialState: initialState,
        listOfK: listOfK,
      );

      final List<ObjectDerivative<T, R>> stepsDerivatives = function(y);
      listOfK.add(stepsDerivatives);

      final double kCoefficient = kCoefficients[step + 1];
      if (kCoefficient != 0) {
        sum.sumMultipliedInPlace(stepsDerivatives, kCoefficient);
      }
    }

    final List<ObjectState<T, R>> newState = initialState.toList();
    newState.sumInPlaceWithDerivatives(sum, delta);

    return newState;
  }

  List<ObjectState<T, R>> _getYForStep<T extends Vector, R>({
    required int step,
    required double delta,
    required List<ObjectState<T, R>> initialState,
    required List<List<ObjectDerivative<T, R>>> listOfK,
  }) {
    final List<ObjectState<T, R>> y = initialState.toList();

    for (int i = 0; i < stepsCoefficients[step].length; i++) {
      final double coefficient = stepsCoefficients[step][i];
      if (coefficient == 0) {
        continue;
      }

      y.sumInPlaceWithDerivatives(listOfK[i], delta * coefficient);
    }

    return y;
  }
}
