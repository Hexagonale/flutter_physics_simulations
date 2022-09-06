import 'package:physics/physics.dart';

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
    final Vector2 newPositionA = a.position + aState.velocity * delta;
    final Vector2 newPositionB = b.position + bState.velocity * delta;

    final Vector2 forceA = _calculateForce(newPositionA, newPositionB, aState.velocity, bState.velocity);
    final Vector2 forceB = -forceA;

    final Vector2 accelerationA = forceA / a.mass;
    final Vector2 accelerationB = forceB / b.mass;

    final Vector2 velocityA = a.velocity + aState.acceleration * delta;
    final Vector2 velocityB = b.velocity + bState.acceleration * delta;

    return Tuple(
      State.fromVelocityAndAcceleration(velocityA, accelerationA),
      State.fromVelocityAndAcceleration(velocityB, accelerationB),
    );
  }

  Vector2 _calculateForce(Vector2 posA, Vector2 posB, Vector2 velA, Vector2 velB) {
    final Vector2 currentVector = posB - posA;
    // final bool inverted = currentVector.direction != vector.direction;
    final double difference = initialLength - currentVector.distance;
    final Vector2 force = currentVector.withMagnitude(difference * -stiffness);

    return force + _calculateDrag(posA, posB, velA, velB);
  }

  Vector2 _calculateDrag(Vector2 posA, Vector2 posB, Vector2 velA, Vector2 velB) {
    final Vector2 vector = (posB - posA).normalized;
    final Vector2 velocityDifference = velB - velA;
    final double dot = vector.dot(velocityDifference);

    return vector * dot * damping;
  }
}
