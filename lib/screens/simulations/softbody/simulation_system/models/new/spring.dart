import 'package:physics/physics.dart';

import '_new.dart';

class Spring {
  Spring({
    required this.a,
    required this.b,
    this.stiffness = 300.0,
    this.damping = 2.0,
  }) : initialLength = (a.position - b.position).distance;

  final MassPoint a;

  final MassPoint b;

  final double stiffness;

  final double damping;

  final double initialLength;

  /// Returns Tuple of `[x acceleration, y acceleration, x velocity, y velocity]` for each of 2 attached masses.
  ///
  /// [aState] is `[a's x velocity, a's y velocity, a's x position, a's y position]`
  /// [bState] is `[b's x velocity, b's y velocity, b's x position, b's y position]`
  Tuple<ObjectDerivative<Vector2, MassPoint>> calculateK(
      ObjectState<Vector2, MassPoint> aState, ObjectState<Vector2, MassPoint> bState) {
    final Vector2 forceA = _calculateForce(aState.position, bState.position, aState.velocity, bState.velocity);
    final Vector2 forceB = -forceA;

    final Vector2 accelerationA = forceA / a.mass;
    final Vector2 accelerationB = forceB / b.mass;

    final ObjectDerivative<Vector2, MassPoint> aDerivative = ObjectDerivative<Vector2, MassPoint>(
      object: aState.object,
      velocity: aState.velocity,
      acceleration: accelerationA,
    );

    final ObjectDerivative<Vector2, MassPoint> bDerivative = ObjectDerivative<Vector2, MassPoint>(
      object: bState.object,
      velocity: bState.velocity,
      acceleration: accelerationB,
    );

    return Tuple<ObjectDerivative<Vector2, MassPoint>>(
      aDerivative,
      bDerivative,
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
