import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:physics/physics.dart';
import 'package:reliable_interval_timer/reliable_interval_timer.dart';

/// Parent class for the all of the physics simulations.
///
/// Takes care of setting up physics iteration timer [_updateTimer]
/// with the given [updateFrequency].
///
/// Integrates [states] using the given [solver] and [getDerivativesForStates].
///
/// [simulationSpeed] can be used to adjust speed of the simulation. By default it is real time.
abstract class SimulationEngine<T extends Vector, R> {
  SimulationEngine({
    required this.solver,
    required this.updateFrequency,
    required this.states,
    this.simulationSpeed = 1.0,
  });

  final OdeSolver solver;

  final Duration updateFrequency;

  List<ObjectState<T, R>> states;

  double simulationSpeed;

  /// Timer that runs every simulation frame.
  ///
  /// Initialized in the [init].
  ReliableIntervalTimer? _updateTimer;

  /// Takes care of storing the delta time.
  final Stopwatch _stopwatch = Stopwatch();

  @mustCallSuper
  void init() {
    _updateTimer = ReliableIntervalTimer(
      interval: updateFrequency,
      callback: (_) => _update(),
    )..start();

    _stopwatch.start();
  }

  @mustCallSuper
  void dispose() {
    _updateTimer?.stop();

    _stopwatch.stop();
  }

  /// Called every simulation frame.
  void _update() {
    final double delta = _stopwatch.elapsedMicroseconds / 1000 / 1000;
    _stopwatch.reset();

    preUpdate(delta);

    states = solver.solve(
      function: getDerivativesForStates,
      initialState: states,
      delta: delta,
    );

    update(delta);
  }

  /// Called before the [states] are updated.
  void preUpdate(double delta) {}

  /// Called after the [states] are updated.
  void update(double delta) {}

  /// See `function` parameter to the [OdeSolver.solve].
  List<ObjectDerivative<T, R>> getDerivativesForStates(List<ObjectState<T, R>> states);
}
