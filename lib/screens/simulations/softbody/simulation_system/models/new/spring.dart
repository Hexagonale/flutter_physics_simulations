import 'dart:ui';

import 'package:physics/utils/_utils.dart';

import '_new.dart';

class Spring {
  Spring({
    required this.a,
    required this.b,
    this.stiffness = 400.0,
    this.damping = 10.0,
  }) : initialLength = (a.position - b.position).distance;

  final MassPoint a;

  final MassPoint b;

  final double stiffness;

  final double damping;

  final double initialLength;

  Tuple<State> calculateK(State aState, State bState, double delta) {
    final Offset newPositionA = a.position + aState.velocity * delta;
    final Offset newPositionB = b.position + bState.velocity * delta;

    final Offset forceA = _calculateForce(newPositionA, newPositionB, aState.velocity, bState.velocity);
    final Offset forceB = -forceA;

    final Offset accelerationA = forceA / a.mass;
    final Offset accelerationB = forceB / b.mass;

    final Offset velocityA = a.velocity + aState.acceleration * delta;
    final Offset velocityB = b.velocity + bState.acceleration * delta;

    return Tuple(
      State.fromVelocityAndAcceleration(velocityA, accelerationA),
      State.fromVelocityAndAcceleration(velocityB, accelerationB),
    );
  }

  Offset _calculateForce(Offset posA, Offset posB, Offset velA, Offset velB) {
    final Offset currentVector = posB - posA;
    // final bool inverted = currentVector.direction != vector.direction;
    final double difference = initialLength - currentVector.distance;
    final Offset force = currentVector.withMagnitude(difference * -stiffness);

    return force + _calculateDrag(posA, posB, velA, velB);
  }

  Offset _calculateDrag(Offset posA, Offset posB, Offset velA, Offset velB) {
    final Offset vector = (posB - posA).normalized;
    final Offset velocityDifference = velB - velA;
    final double dot = vector.dot(velocityDifference);

    return vector * dot * damping;
  }
}
