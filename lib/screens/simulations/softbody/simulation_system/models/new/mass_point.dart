import 'dart:ui';

class MassPoint {
  MassPoint(
    this.mass,
    this.position,
  );

  final double mass;

  Offset position;

  Offset velocity = Offset.zero;

  Offset force = Offset.zero;

  Offset velocityChange = Offset.zero;

  Offset positionChange = Offset.zero;

  void clearForces() {
    force = Offset.zero;
  }

  void applyForce(Offset force) {
    this.force += force;
  }

  void update(double delta) {
    velocity += velocityChange;
    position += positionChange;

    velocityChange = Offset.zero;
    positionChange = Offset.zero;

    // velocity += force / mass * delta * 0.1;
    // position += velocity * delta * 0.1;
  }
}
