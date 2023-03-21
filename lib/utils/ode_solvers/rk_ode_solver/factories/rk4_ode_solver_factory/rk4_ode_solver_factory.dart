import 'package:physics/physics.dart';

class Rk4OdeSolverFactory {
  const Rk4OdeSolverFactory();

  static const List<List<double>> _stepsCoefficients = <List<double>>[
    <double>[0.5],
    <double>[0.0, 0.5],
    <double>[0.0, 0.0, 1.0],
  ];

  static const List<double> _kCoefficients = <double>[
    1 / 6,
    1 / 3,
    1 / 3,
    1 / 6,
  ];

  RkOdeSolver build() {
    return const RkOdeSolver(
      stepsCoefficients: _stepsCoefficients,
      kCoefficients: _kCoefficients,
    );
  }
}
