import 'package:physics/physics.dart';

class MassPoint {
  MassPoint({
    required this.mass,
    required this.position,
  });

  final double mass;
  final Vector2 position;

  static ObjectDerivative<Vector2, MassPoint> calculateK(ObjectState<Vector2, MassPoint> state) {
    final Vector2 gravityForce = _getGravityForce(state.object.mass);
    final Vector2 dragForce = _getDrag(state.velocity);
    // final Offset collisionForce = _getCollisionForce(position, state.acceleration);

    final Vector2 totalForce = gravityForce + dragForce;
    final Vector2 acceleration = totalForce / state.object.mass;

    return ObjectDerivative<Vector2, MassPoint>(
      object: state.object,
      velocity: state.velocity,
      acceleration: acceleration,
    );
  }

  static Vector2 _getGravityForce(double mass) {
    return const Vector2(0.0, 9.8) * mass;
  }

  static Vector2 _getDrag(Vector2 velocity) {
    if (velocity.distanceSquared == 0) {
      return Vector2.zero;
    }

    return velocity.withMagnitude(velocity.distanceSquared) * -0.0005;
  }
}
