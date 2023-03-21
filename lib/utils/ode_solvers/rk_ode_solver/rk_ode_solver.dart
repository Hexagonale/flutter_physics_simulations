import 'package:physics/physics.dart';

/// Flexible Runge-Kutta ODE solver.
class RkOdeSolver extends OdeSolver {
  const RkOdeSolver();

  // static const List<List<double>> stepsCoefficients = <List<double>>[
  //   <double>[0.5],
  //   <double>[0.0, 0.5],
  //   <double>[0.0, 0.0, 1.0],
  // ];

  // static const List<double> kCoefficients = <double>[
  //   1 / 6,
  //   1 / 3,
  //   1 / 3,
  //   1 / 6,
  // ];

  static const List<List<double>> stepsCoefficients = <List<double>>[
    <double>[1 / 5],
    <double>[3 / 10, 9 / 40],
    <double>[44 / 45, -56 / 15, 32 / 9],
    <double>[19372 / 6561, -25360 / 2187, 64448 / 6561, -212 / 729],
    <double>[9017 / 3168, -355 / 33, 46732 / 5247, 49 / 176, -5103 / 18656],
    <double>[35 / 384, 0, 500 / 1113, 125 / 192, -2187 / 6784, 11 / 84],
  ];

  static const List<double> kCoefficients = <double>[
    5179 / 57600,
    0,
    7571 / 16695,
    393 / 640,
    -92097 / 339200,
    187 / 2100,
    1 / 40,
  ];

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
