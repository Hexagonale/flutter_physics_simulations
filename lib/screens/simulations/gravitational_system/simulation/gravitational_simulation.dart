import 'dart:async';

import 'package:physics/physics.dart';

import '../models/models.dart';

typedef MyDerivative = ObjectDerivative<Vector2, GravitationalObject>;
typedef MyState = ObjectState<Vector2, GravitationalObject>;

class GravitationalSimulation {
  GravitationalSimulation({
    required this.system,
    required this.states,
  });

  final Rk4Solver _solver = Rk4Solver();

  static const Duration _simulationFrameDuration = Duration(microseconds: 25);

  final GravitationalSystem system;

  List<MyState> states;

  double simulationSpeed = 50.0 * 50;

  Timer? _updateTimer;

  late DateTime lastUpdate = DateTime.now();

  void init() {
    for (int i = 0; i < system.objects.length; i++) {
      final GravitationalObject object = system.objects[i];
      if (states.where((MyState state) => state.object == object).isEmpty) {
        continue;
      }

      states[i] = MyState(
        position: Vector2.zero,
        velocity: Vector2.zero,
        object: object,
      );
    }

    _updateTimer?.cancel();

    _updateTimer = Timer.periodic(
      _simulationFrameDuration,
      (_) => _updateSimulation(),
    );
  }

  void dispose() {
    _updateTimer?.cancel();
  }

  Vector2 get massCenter {
    Vector2 massCenter = Vector2.zero;

    double massesSum = 0.0;
    for (int i = 0; i < system.objects.length; i++) {
      final MyState state = states[i];

      massCenter += state.position * state.object.mass;
      massesSum += state.object.mass;
    }

    return massCenter / massesSum;
  }

  void _updateSimulation() {
    final DateTime now = DateTime.now();
    final Duration deltaDuration = now.difference(lastUpdate);
    final double delta = deltaDuration.inMicroseconds / 1000 / 1000;

    final double simulatedDeltaTime = delta * simulationSpeed;

    states = _solver.solve<Vector2, GravitationalObject>(
      function: calculateK,
      initialState: states,
      delta: simulatedDeltaTime,
    );

    lastUpdate = now;
  }

  List<MyDerivative> calculateK(List<MyState> states) {
    final List<MyDerivative> derivatives = <MyDerivative>[];

    for (int i = 0; i < states.length; i++) {
      final MyState state = states[i];
      final Vector2 force = _getForcesForObject(states, i);

      final MyDerivative derivative = MyDerivative(
        acceleration: force / state.object.mass,
        velocity: state.velocity,
        object: state.object,
      );

      derivatives[i] = derivative;
    }

    return derivatives;
  }

  Vector2 _getForcesForObject(List<MyState> states, int index) {
    final MyState objectState = states[index];

    Vector2 forcesSum = Vector2.zero;

    for (final MyState relativeState in states) {
      if (relativeState == objectState) {
        continue;
      }

      final Vector2 gravityVector = relativeState.position - objectState.position;
      final double distanceSquared = gravityVector.distanceSquared;
      if (distanceSquared < 1) {
        forcesSum += gravityVector.withMagnitude(0.001);

        continue;
      }

      final double magnitude =
          (system.gravitationalConstant * relativeState.object.mass * objectState.object.mass) / distanceSquared;
      final Vector2 force = gravityVector.withMagnitude(magnitude);

      forcesSum += force;
    }

    return forcesSum;
  }
}
