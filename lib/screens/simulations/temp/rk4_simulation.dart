import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart' hide State;
import 'package:flutter/scheduler.dart';
import 'package:physics/utils/rk4/rk4_solver.dart';

class Rk4SimulationEngine {
  Rk4SimulationEngine({
    required this.tickerProvider,
  });

  final TickerProvider tickerProvider;

  final Rk4Solver _solver = Rk4Solver();

  static const double _armLength = 0.5;

  double angle = -1.0;

  double angularVelocity = 0.0;

  final ValueNotifier<double> _valueNotifier = ValueNotifier<double>(0.0);

  late final Ticker _ticker = tickerProvider.createTicker(
    (_) => _updateNotifier(),
  );

  late final Timer _simTimer;

  late int _lastUpdate = DateTime.now().microsecondsSinceEpoch;

  void init() async {
    _simTimer = Timer.periodic(
      const Duration(milliseconds: 5),
      (_) => _updateSim(),
    );

    _ticker.start();
  }

  void dispose() {
    _simTimer.cancel();

    _ticker.stop();
    _ticker.dispose();

    _valueNotifier.dispose();
  }

  void _updateSim() {
    final int now = DateTime.now().microsecondsSinceEpoch;
    final int deltaUs = now - _lastUpdate;
    final double delta = deltaUs / 1000 / 1000;

    final List<double> newState = _solver.solve(
      function: calculateK,
      initialState: <double>[
        angularVelocity,
        angle,
      ],
      delta: delta,
    );

    angularVelocity = newState[0];
    angle = newState[1];

    _lastUpdate = now;
  }

  /// Should return
  List<double> calculateK(List<double> state) {
    final double acceleration = getAcceleration(state);
    final double velocity = state[0];

    return <double>[
      acceleration,
      velocity,
    ];
  }

  double getAcceleration(List<double> state) {
    final double airResistance = state[0] * state[0] * state[0].sign * -0.03;
    final double gravityForce = 9.8 * _armLength * sin(state[1]);

    return airResistance + gravityForce;
  }

  Future<void> _updateNotifier() async {
    _valueNotifier.value = angle;
  }

  Offset get position {
    final Offset position = Offset(
      sin(angle) * _armLength,
      -cos(angle) * _armLength,
    );

    return position + offset;
  }

  Offset get offset {
    return const Offset(3.0, 3.0);
  }

  Listenable get listenable {
    return _valueNotifier;
  }
}
