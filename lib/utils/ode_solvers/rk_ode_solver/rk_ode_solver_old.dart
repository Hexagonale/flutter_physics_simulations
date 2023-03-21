import 'package:physics/physics.dart';

/// Flexible Runge-Kutta ODE solver.
class RkOdeSolver extends OdeSolver {
  const RkOdeSolver();

  static const List<List<double>> coefficients = <List<double>>[
    <double>[0.5, 2.0],
    <double>[0, 0.5, 2.0],
    <double>[0, 0, 1, 1.0],
  ];

  static const double sqrt21 = 4.58257569495584000680;

  static const double a21 = 1.0 / 2.0;
  static const double a31 = 1.0 / 4.0;
  static const double a32 = 1.0 / 4.0;
  static const double a41 = 1.0 / 7.0;
  static const double a42 = -(7.0 + 3.0 * sqrt21) / 98.0;
  static const double a43 = (21.0 + 5.0 * sqrt21) / 49.0;
  static const double a51 = (11.0 + sqrt21) / 84.0;
  static const double a53 = (18.0 + 4.0 * sqrt21) / 63.0;
  static const double a54 = (21.0 - sqrt21) / 252.0;
  static const double a61 = (5.0 + sqrt21) / 48.0;
  static const double a63 = (9.0 + sqrt21) / 36.0;
  static const double a64 = (-231.0 + 14.0 * sqrt21) / 360.0;
  static const double a65 = (63.0 - 7.0 * sqrt21) / 80.0;
  static const double a71 = (10.0 - sqrt21) / 42.0;
  static const double a73 = (-432.0 + 92.0 * sqrt21) / 315.0;
  static const double a74 = (633.0 - 145.0 * sqrt21) / 90.0;
  static const double a75 = (-504.0 + 115.0 * sqrt21) / 70.0;
  static const double a76 = (63.0 - 13.0 * sqrt21) / 35.0;
  static const double a81 = 1.0 / 14.0;
  static const double a85 = (14.0 - 3.0 * sqrt21) / 126.0;
  static const double a86 = (13.0 - 3.0 * sqrt21) / 63.0;
  static const double a87 = 1.0 / 9.0;
  static const double a91 = 1.0 / 32.0;
  static const double a95 = (91.0 - 21.0 * sqrt21) / 576.0;
  static const double a96 = 11.0 / 72.0;
  static const double a97 = -(385.0 + 75.0 * sqrt21) / 1152.0;
  static const double a98 = (63.0 + 13.0 * sqrt21) / 128.0;
  static const double a10_1 = 1.0 / 14.0;
  static const double a10_5 = 1.0 / 9.0;
  static const double a10_6 = -(733.0 + 147.0 * sqrt21) / 2205.0;
  static const double a10_7 = (515.0 + 111.0 * sqrt21) / 504.0;
  static const double a10_8 = -(51.0 + 11.0 * sqrt21) / 56.0;
  static const double a10_9 = (132.0 + 28.0 * sqrt21) / 245.0;
  static const double a11_5 = (-42.0 + 7.0 * sqrt21) / 18.0;
  static const double a11_6 = (-18.0 + 28.0 * sqrt21) / 45.0;
  static const double a11_7 = -(273.0 + 53.0 * sqrt21) / 72.0;
  static const double a11_8 = (301.0 + 53.0 * sqrt21) / 72.0;
  static const double a11_9 = (28.0 - 28.0 * sqrt21) / 45.0;
  static const double a11_10 = (49.0 - 7.0 * sqrt21) / 18.0;

  static const double b1 = 9.0 / 180.0;
  static const double b8 = 49.0 / 180.0;
  static const double b9 = 64.0 / 180.0;

  @override
  List<ObjectState<T, R>> solve<T extends Vector, R>({
    required List<ObjectDerivative<T, R>> Function(List<ObjectState<T, R>> state) function,
    required List<ObjectState<T, R>> initialState,
    required double delta,
  }) {
    final List<ObjectState<T, R>> y1 = initialState;
    final List<ObjectDerivative<T, R>> k1 = function(y1);

    final List<ObjectState<T, R>> y2 = k1.toState(delta * a21);
    final List<ObjectDerivative<T, R>> k2 = function(initialState.sum(y2));

    final List<ObjectState<T, R>> y3 = k1.toState(delta * a31);
    y3.sumInPlace(k2.toState(delta * a32));
    final List<ObjectDerivative<T, R>> k3 = function(initialState.sum(y3));

    final List<ObjectState<T, R>> y4 = k1.toState(delta * a41);
    y4.sumInPlace(k2.toState(delta * a42));
    y4.sumInPlace(k3.toState(delta * a43));
    final List<ObjectDerivative<T, R>> k4 = function(initialState.sum(y4));

    final List<ObjectState<T, R>> y5 = k1.toState(delta * a51);
    y5.sumInPlace(k3.toState(delta * a53));
    y5.sumInPlace(k4.toState(delta * a54));
    final List<ObjectDerivative<T, R>> k5 = function(initialState.sum(y5));

    final List<ObjectState<T, R>> y6 = k1.toState(delta * a61);
    y6.sumInPlace(k3.toState(delta * a63));
    y6.sumInPlace(k4.toState(delta * a64));
    y6.sumInPlace(k5.toState(delta * a65));
    final List<ObjectDerivative<T, R>> k6 = function(initialState.sum(y6));

    final List<ObjectState<T, R>> y7 = k1.toState(delta * a71);
    y7.sumInPlace(k3.toState(delta * a73));
    y7.sumInPlace(k4.toState(delta * a74));
    y7.sumInPlace(k5.toState(delta * a75));
    y7.sumInPlace(k6.toState(delta * a76));
    final List<ObjectDerivative<T, R>> k7 = function(initialState.sum(y7));

    final List<ObjectState<T, R>> y8 = k1.toState(delta * a81);
    y8.sumInPlace(k5.toState(delta * a85));
    y8.sumInPlace(k6.toState(delta * a86));
    y8.sumInPlace(k7.toState(delta * a87));
    final List<ObjectDerivative<T, R>> k8 = function(initialState.sum(y8));

    final List<ObjectState<T, R>> y9 = k1.toState(delta * a81);
    y9.sumInPlace(k5.toState(delta * a85));
    y9.sumInPlace(k6.toState(delta * a86));
    y9.sumInPlace(k7.toState(delta * a87));
    final List<ObjectDerivative<T, R>> k9 = function(initialState.sum(y9));

    final List<ObjectState<T, R>> y10 = k1.toState(delta * a10_1);
    y10.sumInPlace(k5.toState(delta * a10_5));
    y10.sumInPlace(k6.toState(delta * a10_6));
    y10.sumInPlace(k7.toState(delta * a10_7));
    y10.sumInPlace(k8.toState(delta * a10_8));
    y10.sumInPlace(k9.toState(delta * a10_9));
    final List<ObjectDerivative<T, R>> k10 = function(initialState.sum(y10));

    final List<ObjectState<T, R>> y11 = k5.toState(delta * a11_5);
    y11.sumInPlace(k6.toState(delta * a11_6));
    y11.sumInPlace(k7.toState(delta * a11_7));
    y11.sumInPlace(k8.toState(delta * a11_8));
    y11.sumInPlace(k9.toState(delta * a11_9));
    y11.sumInPlace(k10.toState(delta * a11_10));
    final List<ObjectDerivative<T, R>> k11 = function(initialState.sum(y11));

    final List<ObjectDerivative<T, R>> sum = k1 * b1;
    sum.sumInPlace(k8 * b8);
    sum.sumInPlace(k9 * b9);
    sum.sumInPlace(k10 * b8);
    sum.sumInPlace(k11 * b1);

    return initialState.sum(sum.toState(delta));
  }

  // @override
  // List<ObjectState<T, R>> solve<T extends Vector, R>({
  //   required List<ObjectDerivative<T, R>> Function(List<ObjectState<T, R>> state) function,
  //   required List<ObjectState<T, R>> initialState,
  //   required double delta,
  // }) {
  //   final List<ObjectState<T, R>> y1 = initialState;
  //   final List<ObjectDerivative<T, R>> k1 = function(y1);

  //   // 1/5
  //   final List<ObjectState<T, R>> y2 = k1.toState(delta * 0.2);
  //   final List<ObjectDerivative<T, R>> k2 = function(initialState.sum(y2));

  //   // 3/40 9/40
  //   final List<ObjectState<T, R>> y3 = k1.toState(delta * (3 / 40));
  //   y3.sumInPlace(k2.toState(delta * (9 / 40)));
  //   final List<ObjectDerivative<T, R>> k3 = function(initialState.sum(y3));

  //   // 44/45 −56/15 32/9
  //   final List<ObjectState<T, R>> y4 = k1.toState(delta * (44 / 45));
  //   y4.sumInPlace(k2.toState(delta * -(56 / 15)));
  //   y4.sumInPlace(k3.toState(delta * (32 / 9)));
  //   final List<ObjectDerivative<T, R>> k4 = function(initialState.sum(y4));

  //   // 19372/6561 −25360/2187 64448/6561 −212/729
  //   final List<ObjectState<T, R>> y5 = k1.toState(delta * (19372 / 6561));
  //   y5.sumInPlace(k2.toState(delta * -(25360 / 2187)));
  //   y5.sumInPlace(k3.toState(delta * (64448 / 6561)));
  //   y5.sumInPlace(k4.toState(delta * -(212 / 729)));
  //   final List<ObjectDerivative<T, R>> k5 = function(initialState.sum(y5));

  //   // 9017/3168 −355/33 46732/5247 49/176 −5103/18656
  //   final List<ObjectState<T, R>> y6 = k1.toState(delta * (9017 / 3168));
  //   y6.sumInPlace(k2.toState(delta * -(355 / 33)));
  //   y6.sumInPlace(k3.toState(delta * (46732 / 5247)));
  //   y6.sumInPlace(k4.toState(delta * (49 / 176)));
  //   y6.sumInPlace(k5.toState(delta * -(5103 / 18656)));
  //   final List<ObjectDerivative<T, R>> k6 = function(initialState.sum(y6));

  //   // 35/384 0 500/1113 125/192 −2187/6784 11/84
  //   final List<ObjectState<T, R>> y7 = k1.toState(delta * (35 / 384));
  //   y7.sumInPlace(k3.toState(delta * (500 / 1113)));
  //   y7.sumInPlace(k4.toState(delta * (125 / 192)));
  //   y7.sumInPlace(k5.toState(delta * -(2187 / 6784)));
  //   y7.sumInPlace(k6.toState(delta * (11 / 84)));
  //   final List<ObjectDerivative<T, R>> k7 = function(initialState.sum(y7));

  //   // 5179/57600 0 7571/16695 393/640 −92097/339200 187/2100 1/40
  //   final List<ObjectDerivative<T, R>> sum = k1 * (5179 / 57600);
  //   sum.sumInPlace(k3 * (7571 / 16695));
  //   sum.sumInPlace(k4 * (393 / 640));
  //   sum.sumInPlace(k5 * -(92097 / 339200));
  //   sum.sumInPlace(k6 * (187 / 2100));
  //   sum.sumInPlace(k7 * (1 / 40));

  //   return initialState.sum(sum.toState(delta));
  // }

  // @override
  // List<ObjectState<T, R>> solve<T extends Vector, R>({
  //   required List<ObjectDerivative<T, R>> Function(List<ObjectState<T, R>> state) function,
  //   required List<ObjectState<T, R>> initialState,
  //   required double delta,
  // }) {
  //   final List<ObjectState<T, R>> y1 = initialState;
  //   final List<ObjectDerivative<T, R>> k1 = function(y1);

  //   final List<ObjectState<T, R>> y2 = k1.toState(delta * 0.5);
  //   final List<ObjectDerivative<T, R>> k2 = function(initialState.sum(y2));

  //   final List<ObjectState<T, R>> y3 = k1.toState(delta * -(1 / 3));
  //   y3.sumInPlace(k2.toState(delta));
  //   final List<ObjectDerivative<T, R>> k3 = function(initialState.sum(y3));

  //   final List<ObjectState<T, R>> y4 = k1.toState(delta);
  //   y4.sumInPlace(k2.toState(delta * -1));
  //   y4.sumInPlace(k3.toState(delta));
  //   final List<ObjectDerivative<T, R>> k4 = function(initialState.sum(y4));

  //   k1.sumInPlace(k2 * 3);
  //   k1.sumInPlace(k3 * 3);
  //   k1.sumInPlace(k4);
  //   return initialState.sum(k1.toState(delta / 8));
  // }

  //  @override
  // List<ObjectState<T, R>> solve<T extends Vector, R>({
  //   required List<ObjectDerivative<T, R>> Function(List<ObjectState<T, R>> state) function,
  //   required List<ObjectState<T, R>> initialState,
  //   required double delta,
  // }) {
  //   final List<List<ObjectDerivative<T, R>>> listOfK = <List<ObjectDerivative<T, R>>>[
  //     function(initialState),
  //   ];

  //   final List<ObjectDerivative<T, R>> sum = listOfK.first;
  //   for (int s = 0; s < RkOdeSolver.coefficients.length; s++) {
  //     final List<double> coefficients = RkOdeSolver.coefficients[s];
  //     final List<ObjectDerivative<T, R>> k = listOfK[s];

  //     final List<ObjectState<T, R>> stateSum = initialState.toList();
  //     for (int i = 0; i < coefficients.length; i++) {
  //       final double coefficient = coefficients[i];
  //       if (coefficient == 0) {
  //         continue;
  //       }

  //       final List<ObjectState<T, R>> state = k.toState(delta * coefficient);
  //       stateSum.sumInPlace(state);
  //     }

  //     final List<ObjectDerivative<T, R>> currentK = function(initialState.sum(stateSum));

  //     listOfK.add(currentK);
  //     sum.sumInPlace(currentK);
  //   }

  //   return sum.toState(delta / sumDenominator);
  // }
}
