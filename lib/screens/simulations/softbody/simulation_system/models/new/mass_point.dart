import 'package:physics/physics.dart';

import '_new.dart';

class MassPoint {
  MassPoint(
    this.mass,
    this.position,
  );

  final double mass;

  Vector2 position;

  Vector2 velocity = Vector2.zero;

  Vector2 appliedForces = Vector2.zero;

  void clearForces() {
    appliedForces = Vector2.zero;
  }

  void applyForce(Vector2 force) {
    appliedForces += force;
  }

  void update(State change) {
    velocity += change.acceleration;
    position += change.velocity;
  }

  State calculateK(State state, double delta) {
    final Vector2 newPosition = position + state.velocity * delta;

    final Vector2 gravityForce = _getGravityForce();
    final Vector2 dragForce = _getDrag(state.velocity);
    final Vector2 collisionForce = _getCollisionForce(newPosition, state.acceleration);

    final Vector2 totalForce = gravityForce + dragForce + collisionForce + appliedForces;

    final Vector2 acceleration = totalForce / mass;
    final Vector2 velocity = this.velocity + state.acceleration * delta;

    return State.fromVelocityAndAcceleration(velocity, acceleration);
  }

  Vector2 _getGravityForce() {
    return const Vector2(0.0, 9.8) * mass;
  }

  Vector2 _getDrag(Vector2 velocity) {
    if (velocity.distanceSquared == 0) {
      return Vector2.zero;
    }

    return velocity.withMagnitude(velocity.distanceSquared) * -0.005;
  }

  Vector2 _getCollisionForce(Vector2 position, Vector2 acceleration) {
    if (position.dy < 1.0) {
      return Vector2.zero;
    }

    final double verticalForce = acceleration.dy * mass;
    if (verticalForce < 0.0) {
      return Vector2.zero;
    }

    return Vector2.zero;
    // return Vector2(0.0, -verticalForce);
  }
}
