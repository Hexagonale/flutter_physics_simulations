import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:physics/physics.dart';

class Rk4SimulationEngine {
  Rk4SimulationEngine({
    required this.tickerProvider,
  });

  final TickerProvider tickerProvider;

  final Rk4Solver _solver = Rk4Solver();

  static const double _armLength = 0.5;

  Vector1 angle = const Vector1(-1.0);

  Vector1 angularVelocity = const Vector1(0.0);

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

    final List<ObjectState<Vector1>> newState = _solver.solve(
      function: calculateK,
      initialState: <ObjectState<Vector1>>[
        ObjectState<Vector1>(
          velocity: angularVelocity,
          position: angle,
        ),
      ],
      delta: delta,
    );

    angularVelocity = newState[0].velocity;
    angle = newState[0].position;

    _lastUpdate = now;
  }

  /// Should return
  List<ObjectDerivative<Vector1>> calculateK(List<ObjectState<Vector1>> states) {
    final ObjectState<Vector1> state = states.first;

    final Vector1 acceleration = getAcceleration(state);
    final Vector1 velocity = state.velocity;

    return <ObjectDerivative<Vector1>>[
      ObjectDerivative<Vector1>(
        acceleration: acceleration,
        velocity: velocity,
      )
    ];
  }

  Vector1 getAcceleration(ObjectState<Vector1> state) {
    final double airResistance = state.velocity.value * state.velocity.value * state.velocity.value.sign * -0.03;
    final double gravityForce = 9.8 * _armLength * sin(state.position.value);

    return Vector1(airResistance + gravityForce);
  }

  Future<void> _updateNotifier() async {
    _valueNotifier.value = angle.value;
  }

  Offset get position {
    final Offset position = Offset(
      sin(angle.value) * _armLength,
      -cos(angle.value) * _armLength,
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
