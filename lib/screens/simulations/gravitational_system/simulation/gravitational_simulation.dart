import 'dart:async';

import 'package:physics/physics.dart';

import '../models/models.dart';

class GravitationalSimulation {
  GravitationalSimulation({
    required this.system,
    required this.states,
  });

  static const Duration _simulationFrameDuration = Duration(microseconds: 250);

  final GravitationalSystem system;

  final Map<GravitationalObject, ObjectState<Vector2>> states;

  double simulationSpeed = 50.0 * 50;

  Timer? _updateTimer;

  late DateTime lastUpdate = DateTime.now();

  void init() {
    for (final GravitationalObject object in system.objects) {
      if (states.containsKey(object)) {
        continue;
      }

      states[object] = const ObjectState<Vector2>(
        position: Vector2.zero,
        velocity: Vector2.zero,
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
    for (final GravitationalObject object in system.objects) {
      final ObjectState<Vector2>? state = states[object];
      if (state == null) {
        continue;
      }

      massCenter += state.position * object.mass;
      massesSum += object.mass;
    }

    return massCenter / massesSum;
  }

  void _updateSimulation() {
    final DateTime now = DateTime.now();
    final Duration deltaDuration = now.difference(lastUpdate);
    final double delta = deltaDuration.inMicroseconds / 1000 / 1000;

    final double simulatedDeltaTime = delta * simulationSpeed;

    final Map<GravitationalObject, Vector2> forces = <GravitationalObject, Vector2>{};

    for (final GravitationalObject object in system.objects) {
      final Vector2 force = _getForcesForObject(object);

      forces[object] = force;
    }

    for (final MapEntry<GravitationalObject, Vector2> entry in forces.entries) {
      _updateObject(entry.key, entry.value, simulatedDeltaTime);
    }

    lastUpdate = now;
  }

  Vector2 _getForcesForObject(GravitationalObject object) {
    final ObjectState<Vector2>? objectState = states[object];
    if (objectState == null) {
      return Vector2.zero;
    }

    Vector2 forcesSum = Vector2.zero;

    for (final GravitationalObject relativeObject in system.objects) {
      if (relativeObject == object) {
        continue;
      }

      final ObjectState<Vector2>? relativeObjectState = states[relativeObject];
      if (relativeObjectState == null) {
        continue;
      }

      final Vector2 gravityVector = relativeObjectState.position - objectState.position;
      final double distanceSquared = gravityVector.distanceSquared;
      if (distanceSquared < 1) {
        forcesSum += gravityVector.withMagnitude(0.001);

        continue;
      }

      final double magnitude = (system.gravitationalConstant * relativeObject.mass * object.mass) / distanceSquared;
      final Vector2 force = gravityVector.withMagnitude(magnitude);

      forcesSum += force;
    }

    return forcesSum;
  }

  void _updateObject(GravitationalObject object, Vector2 force, double delta) {
    final ObjectState<Vector2>? oldState = states[object];
    if (oldState == null) {
      throw Exception('Error! cannot find old state for the $object!');
    }

    final Vector2 acceleration = force / object.mass;

    final ObjectState<Vector2> stateChange = ObjectState<Vector2>(
      velocity: acceleration * delta,
      position: oldState.velocity * delta,
    );

    states[object] = oldState + stateChange;
  }
}
