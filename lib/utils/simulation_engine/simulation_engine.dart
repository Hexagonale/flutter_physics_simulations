import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:physics/physics.dart';

abstract class SimulationEngine<T extends Vector, R> {
  SimulationEngine({
    required this.updateFrequency,
  });

  final Duration updateFrequency;

  late final Timer _updateTimer;

  final Stopwatch _stopwatch = Stopwatch();

  @mustCallSuper
  void init() {
    _updateTimer = Timer.periodic(
      updateFrequency,
      (Timer timer) => _update(),
    );

    _stopwatch.start();
  }

  @mustCallSuper
  void dispose() {
    _updateTimer.cancel();

    _stopwatch.stop();
  }

  void _update() {
    final double delta = _stopwatch.elapsedMicroseconds / 1000 / 1000;

    update(delta);

    _stopwatch.reset();
    _stopwatch.start();
  }

  void update(double delta);
}
