import 'package:physics/physics.dart';

class Rk5OdeSolverFactory {
  const Rk5OdeSolverFactory();

  static const List<List<double>> _stepsCoefficients = <List<double>>[
    <double>[1 / 5],
    <double>[3 / 10, 9 / 40],
    <double>[44 / 45, -56 / 15, 32 / 9],
    <double>[19372 / 6561, -25360 / 2187, 64448 / 6561, -212 / 729],
    <double>[9017 / 3168, -355 / 33, 46732 / 5247, 49 / 176, -5103 / 18656],
    <double>[35 / 384, 0, 500 / 1113, 125 / 192, -2187 / 6784, 11 / 84],
  ];

  static const List<double> _kCoefficients = <double>[
    5179 / 57600,
    0,
    7571 / 16695,
    393 / 640,
    -92097 / 339200,
    187 / 2100,
    1 / 40,
  ];

  RkOdeSolver build() {
    return const RkOdeSolver(
      stepsCoefficients: _stepsCoefficients,
      kCoefficients: _kCoefficients,
    );
  }
}
