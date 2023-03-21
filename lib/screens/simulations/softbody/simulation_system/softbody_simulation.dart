import 'package:physics/physics.dart';

import 'models/new/_new.dart';

class SoftbodySimulation extends SimulationEngine<Vector2, MassPoint> {
  SoftbodySimulation({
    required this.springs,
    required this.massPointIndexes,
    required super.states,
    super.solver = const RkOdeSolver(),
    super.updateFrequency = const Duration(microseconds: 2250),
    // super.solver = const Rk4Solver(),
    // super.updateFrequency = const Duration(microseconds: 1850),
    super.simulationSpeed = 1,
  });

  factory SoftbodySimulation.fromSoftbody(Softbody softbody) {
    final List<ObjectState<Vector2, MassPoint>> states = <ObjectState<Vector2, MassPoint>>[];
    final Map<MassPoint, int> massPointIndexes = <MassPoint, int>{};

    for (final MassPoint massPoint in softbody.masses) {
      final ObjectState<Vector2, MassPoint> state = ObjectState<Vector2, MassPoint>(
        object: massPoint,
        position: massPoint.position,
        velocity: Vector2.zero,
      );

      massPointIndexes[massPoint] = states.length;
      states.add(state);
    }

    return SoftbodySimulation(
      springs: softbody.springs,
      massPointIndexes: massPointIndexes,
      states: states,
    );
  }

  factory SoftbodySimulation.build([int width = 8]) {
    final Softbody softbody = _createSoftbody(width);

    return SoftbodySimulation.fromSoftbody(softbody);
  }

  final List<Spring> springs;
  final Map<MassPoint, int> massPointIndexes;

  Map<MassPoint, Vector2> appliedForces = <MassPoint, Vector2>{};

  void applyForce() {
    for (int i = 0; i < states.length; i += 10) {
      appliedForces[states[i].object] = const Vector2(0.0, -300.0);
    }
  }

  void clearForce() {
    appliedForces = <MassPoint, Vector2>{};
  }

  @override
  void update(double delta) {
    const double floor = 2.0;

    for (int i = 0; i < states.length; i++) {
      final ObjectState<Vector2, MassPoint> state = states[i];
      if (state.position.dy < floor) {
        continue;
      }

      states[i] = ObjectState<Vector2, MassPoint>(
        object: state.object,
        velocity: Vector2(state.velocity.dx, -state.velocity.dy),
        position: Vector2(state.position.dx, floor - (state.position.dy % floor)),
      );
    }

    super.update(delta);
  }

  @override
  List<ObjectDerivative<Vector2, MassPoint>> getDerivativesForStates(List<ObjectState<Vector2, MassPoint>> states) {
    final List<ObjectDerivative<Vector2, MassPoint>> derivatives = List<ObjectDerivative<Vector2, MassPoint>>.generate(
      states.length,
      (int index) => ObjectDerivative<Vector2, MassPoint>(
        object: states[index].object,
        velocity: Vector2.zero,
        acceleration: Vector2.zero,
      ),
    );

    // Calculate all springs forces.
    for (final Spring spring in springs) {
      final MassPoint a = spring.a;
      final MassPoint b = spring.b;

      final int aIndex = massPointIndexes[a]!;
      final int bIndex = massPointIndexes[b]!;

      final ObjectState<Vector2, MassPoint> aState = states[aIndex];
      final ObjectState<Vector2, MassPoint> bState = states[bIndex];

      final Tuple<ObjectDerivative<Vector2, MassPoint>> newStates = spring.calculateK(aState, bState);
      derivatives[aIndex] += newStates.a;
      derivatives[bIndex] += newStates.b;
    }

    // Calculate all points forces.
    for (int i = 0; i < states.length; i++) {
      final Vector2 appliedForce = appliedForces[states[i].object] ?? Vector2.zero;
      final ObjectDerivative<Vector2, MassPoint> newState = MassPoint.calculateK(states[i]);

      final ObjectDerivative<Vector2, MassPoint> derivative = ObjectDerivative<Vector2, MassPoint>(
        object: states[i].object,
        acceleration: derivatives[i].acceleration + newState.acceleration + appliedForce,
        velocity: states[i].velocity,
      );

      derivatives[i] = derivative;
    }

    return derivatives;
  }

  static Softbody _createSoftbody(int width) {
    const double totalMass = 0.5;
    final int particlesCount = width * width;
    final double particleMass = totalMass / particlesCount;

    final List<MassPoint> particles = <MassPoint>[];
    for (int yi = 0; yi < width; yi++) {
      for (int xi = 0; xi < width; xi++) {
        final double x = xi * 0.05 + 0.5;
        final double y = yi * 0.05 + 1.0;

        final MassPoint particle = MassPoint(
          mass: particleMass,
          position: Vector2(x, y),
        );

        particles.add(particle);
      }
    }

    final List<Spring> connections = <Spring>[];
    for (int yi = 0; yi < width; yi++) {
      for (int xi = 0; xi < width; xi++) {
        final int index = yi * width + xi;
        final int rightIndex = yi * width + xi + 1;
        final int downIndex = yi * width + xi + width;

        if (xi != width - 1) {
          final Spring connection = Spring(
            a: particles[index],
            b: particles[rightIndex],
          );

          connections.add(connection);
        }

        if (yi != width - 1) {
          final Spring connection = Spring(
            a: particles[index],
            b: particles[downIndex],
          );

          connections.add(connection);
        }

        if (yi != width - 1) {
          if (xi != width - 1) {
            final Spring connection = Spring(
              a: particles[index],
              b: particles[downIndex + 1],
            );

            connections.add(connection);
          }

          if (xi != 0) {
            final Spring connection = Spring(
              a: particles[index],
              b: particles[downIndex - 1],
            );

            connections.add(connection);
          }
        }
      }
    }

    return Softbody(
      masses: particles,
      springs: connections,
    );
  }
}
