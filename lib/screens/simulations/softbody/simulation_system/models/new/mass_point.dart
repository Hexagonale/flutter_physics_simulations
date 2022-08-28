import 'dart:ui';

import 'package:physics/utils/_utils.dart';

import '_new.dart';

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

  void update(State change) {
    velocity += change.acceleration;
    position += change.velocity;
  }

  State calculateK(State state, double delta) {
    final Offset newPosition = position + state.velocity * delta;

    final Offset gravityForce = _getGravityForce();
    final Offset dragForce = _getDrag(state.velocity);
    final Offset collisionForce = _getCollisionForce(newPosition, state.acceleration);

    final Offset totalForce = gravityForce + dragForce + collisionForce + appliedForces;

    final Offset acceleration = totalForce / mass;
    final Offset velocity = this.velocity + state.acceleration * delta;

    return State.fromVelocityAndAcceleration(velocity, acceleration);
  }

  Offset _getGravityForce() {
    return const Offset(0.0, 9.8) * mass;
  }

  Offset _getDrag(Offset velocity) {
    if (velocity.distanceSquared == 0) {
      return Offset.zero;
    }

    return velocity.withMagnitude(velocity.distanceSquared) * -0.005;
  }

  Offset _getCollisionForce(Offset position, Offset acceleration) {
    if (position.dy < 1.0) {
      return Offset.zero;
    }

    final double verticalForce = acceleration.dy * mass;
    if (verticalForce < 0.0) {
      return Offset.zero;
    }

    return Offset.zero;
    // return Offset(0.0, -verticalForce);
  }
}
