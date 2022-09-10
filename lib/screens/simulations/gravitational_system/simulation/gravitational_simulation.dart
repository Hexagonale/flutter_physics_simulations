import 'package:physics/physics.dart';

import '../models/_models.dart';

typedef MyDerivative = ObjectDerivative<Vector2, GravitationalObject>;
typedef MyState = ObjectState<Vector2, GravitationalObject>;

class GravitationalSimulation extends SimulationEngine<Vector2, GravitationalObject> {
  GravitationalSimulation({
    required this.system,
    required super.states,
    super.updateFrequency = const Duration(microseconds: 750),
    super.solver = const Rk4Solver(),
    super.simulationSpeed,
  });

  factory GravitationalSimulation.fromSetup(GravitationalSimulationSetup setup) {
    return GravitationalSimulation(
      system: setup.gravitationalSystem,
      states: setup.states,
      simulationSpeed: setup.initialSpeed,
    );
  }

  final GravitationalSystem system;

  @override
  void init() {
    for (int i = 0; i < system.objects.length; i++) {
      final GravitationalObject object = system.objects[i];
      if (states.where((MyState state) => state.object == object).isNotEmpty) {
        continue;
      }

      states[i] = MyState(
        position: Vector2.zero,
        velocity: Vector2.zero,
        object: object,
      );
    }

    super.init();
  }

  @override
  List<MyDerivative> getDerivativesForStates(List<MyState> states) {
    final List<MyDerivative> derivatives = <MyDerivative>[];

    for (int i = 0; i < states.length; i++) {
      final MyState state = states[i];
      final Vector2 force = _getForcesForObject(states, i);

      final MyDerivative derivative = MyDerivative(
        acceleration: force / state.object.mass,
        velocity: state.velocity,
        object: state.object,
      );

      derivatives.add(derivative);
    }

    return derivatives;
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

  Vector2 _getForcesForObject(List<MyState> states, int index) {
    final MyState objectState = states[index];

    Vector2 forcesSum = Vector2.zero;

    for (final MyState relativeState in states) {
      if (relativeState.object == objectState.object) {
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
