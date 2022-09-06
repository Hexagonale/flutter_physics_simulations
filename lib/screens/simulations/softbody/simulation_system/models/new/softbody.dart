import 'dart:ui';

import 'package:physics/physics.dart';

import 'mass_point.dart';
import 'spring.dart';

class Softbody {
  Softbody({
    required this.masses,
    required this.springs,
  }) : massPointIndexes = _generateMassPointIndexes(masses);

  final List<MassPoint> masses;

  final List<Spring> springs;

  final Map<MassPoint, int> massPointIndexes;

  List<State> calculateK(List<State>? states, double delta) {
    List<State> output = List.generate(masses.length, (int _) => State());

    // Calculate all springs forces.
    for (final Spring spring in springs) {
      final MassPoint a = spring.a;
      final MassPoint b = spring.b;

      final int aIndex = massPointIndexes[a]!;
      final int bIndex = massPointIndexes[b]!;

      final State aState = states?[aIndex] ?? State();
      final State bState = states?[bIndex] ?? State();

      Tuple<State> newStates = spring.calculateK(aState, bState, delta);
      output[aIndex] += newStates.a;
      output[bIndex] += newStates.b;
    }

    // Calculate all points forces.
    for (int i = 0; i < masses.length; i++) {
      final MassPoint point = masses[i];
      final State previousState = states?[i] ?? State();

      final State newState = point.calculateK(previousState, delta);
      output[i] += newState;
    }

    return output;
  }

  void update(List<State> states) {
    for (int i = 0; i < masses.length; i++) {
      final MassPoint point = masses[i];

      point.update(states[i]);
      point.clearForces();

      if (point.position.dy >= 1.0) {
        point.position = Vector2(point.position.dx, 1.0);
        point.velocity = Vector2(point.velocity.dx, 0.0);
      }
    }
  }

  static Map<MassPoint, int> _generateMassPointIndexes(List<MassPoint> points) {
    final Map<MassPoint, int> massPointIndexes = <MassPoint, int>{};

    for (int i = 0; i < points.length; i++) {
      final MassPoint point = points[i];
      massPointIndexes[point] = i;
    }

    return massPointIndexes;
  }
}

class State {
  State({
    this.vx = 0,
    this.vy = 0,
    this.ax = 0,
    this.ay = 0,
  });

  factory State.fromVelocityAndAcceleration(Offset velocity, Offset acceleration) {
    return State(
      vx: velocity.dx,
      vy: velocity.dy,
      ax: acceleration.dx,
      ay: acceleration.dy,
    );
  }

  double vx;

  double vy;

  double ax;

  double ay;

  Vector2 get velocity => Vector2(vx, vy);

  Vector2 get acceleration => Vector2(ax, ay);

  State get copy {
    return State(
      vx: vx,
      vy: vy,
      ax: ax,
      ay: ay,
    );
  }

  State operator *(double other) {
    return State.fromVelocityAndAcceleration(
      velocity * other,
      acceleration * other,
    );
  }

  State operator /(double other) {
    return State.fromVelocityAndAcceleration(
      velocity / other,
      acceleration / other,
    );
  }

  State operator +(State other) {
    return State.fromVelocityAndAcceleration(
      velocity + other.velocity,
      acceleration + other.acceleration,
    );
  }

  @override
  String toString() => '$vx $vy $ax $ay';
}
