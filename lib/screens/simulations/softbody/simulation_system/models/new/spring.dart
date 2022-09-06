import 'dart:ui';

import 'package:physics/utils/_utils.dart';

import '_new.dart';

class Spring {
  Spring({
    required this.a,
    required this.b,
    this.stiffness = 800.0,
    this.damping = 10.0,
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
  Tuple<List<double>> calculateK(List<double> aState, List<double> bState) {
    final Offset aVelocity = Offset(aState[0], aState[1]);
    final Offset bVelocity = Offset(bState[0], bState[1]);

    final Offset aPosition = Offset(aState[2], aState[3]);
    final Offset bPosition = Offset(bState[2], bState[3]);

    final Offset forceA = _calculateForce(aPosition, bPosition, aVelocity, bVelocity);
    final Offset forceB = -forceA;

    final Offset accelerationA = forceA / a.mass;
    final Offset accelerationB = forceB / b.mass;

    return Tuple(
      <double>[
        accelerationA.dx,
        accelerationA.dy,
        aVelocity.dx,
        aVelocity.dy,
      ],
      <double>[
        accelerationB.dx,
        accelerationB.dy,
        bVelocity.dx,
        bVelocity.dy,
      ],
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
