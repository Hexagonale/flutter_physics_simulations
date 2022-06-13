import 'dart:math';
import 'dart:ui';

import 'package:physics/utils/_utils.dart';

import 'mass_point.dart';
import 'spring.dart';

class Softbody {
  Softbody({
    required this.masses,
    required this.springs,
  });

  final List<MassPoint> masses;

  final List<Spring> springs;

  List<State> calculateK(List<State>? states, double delta) {
    List<State> output = List.generate(masses.length, (int _) => State());

    for (final Spring spring in springs) {
      final MassPoint a = spring.a;
      final MassPoint b = spring.b;

      final int aIndex = masses.indexOf(a);
      final int bIndex = masses.indexOf(b);

      final State aState = states?[aIndex] ?? State();
      final State bState = states?[bIndex] ?? State();

      Tuple<State> newStates = spring.calculateK(aState, bState, delta);
      output[aIndex] += newStates.a;
      output[bIndex] += newStates.b;
    }

    for (int i = 0; i < masses.length; i++) {
      final MassPoint point = masses[i];
      final double currentVelocity = point.velocity.dy;
      final double previousAcceleration = states?[i].ay ?? 0;

      output[i].ay += 9.8;
      output[i].vy += currentVelocity + previousAcceleration * delta;
    }

    return output;
  }

  void update(List<State> states) {
    for (int i = 0; i < masses.length; i++) {
      final MassPoint point = masses[i];

      point.update(states[i]);
      point.clearForces();

      if (point.position.dy >= 1.0) {
        point.position = Offset(point.position.dx, 1.0);
        point.velocity = Offset(point.velocity.dx, max(point.velocity.dy, 0));
      }
    }
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

  Offset get velocity => Offset(vx, vy);

  Offset get acceleration => Offset(ax, ay);

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
