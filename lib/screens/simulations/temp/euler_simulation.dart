import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

class EulerSimulationEngine {
  EulerSimulationEngine({
    required this.tickerProvider,
  });

  final TickerProvider tickerProvider;

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
      const Duration(microseconds: 2),
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

    final double acceleration = getAcceleration();
    angularVelocity += acceleration * delta;
    angle += angularVelocity * delta;

    _lastUpdate = now;
  }

  double getAcceleration() {
    final double airResistance = angularVelocity * angularVelocity * angularVelocity.sign * -0.03;
    final double gravityForce = 9.8 * _armLength * sin(angle);

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
