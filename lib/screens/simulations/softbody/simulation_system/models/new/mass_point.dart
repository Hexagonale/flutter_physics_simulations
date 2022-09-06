import 'dart:ui';

import 'package:physics/utils/_utils.dart';

class MassPoint {
  MassPoint(
    this.mass,
    this.position,
  );

  final double mass;

  Offset position;

  Offset velocity = Offset.zero;

  Offset appliedForces = Offset.zero;

  void clearForces() {
    appliedForces = Offset.zero;
  }

  void applyForce(Offset force) {
    appliedForces += force;
  }

  /// Returns `[x acceleration, y acceleration, x velocity, y velocity]` for this mass point.
  ///
  /// [state] is `[x velocity, y velocity, x position, y position]`
  List<double> calculateK(List<double> state) {
    final Offset velocity = Offset(state[0], state[1]);
    // final Offset position = Offset(state[2], state[3]);

    final Offset gravityForce = _getGravityForce();
    final Offset dragForce = _getDrag(velocity);
    // final Offset collisionForce = _getCollisionForce(position, state.acceleration);

    final Offset totalForce = gravityForce + dragForce + appliedForces;
    final Offset acceleration = totalForce / mass;

    return <double>[
      acceleration.dx,
      acceleration.dy,
      velocity.dx,
      velocity.dy,
    ];
  }

  Offset _getGravityForce() {
    return const Offset(0.0, 9.8) * mass;
  }

  Offset _getDrag(Offset velocity) {
    if (velocity.distanceSquared == 0) {
      return Offset.zero;
    }

    return velocity.withMagnitude(velocity.distanceSquared) * -0.0005;
  }
}
