import 'dart:ui';

import '_new.dart';

class MassPoint {
  MassPoint(
    this.mass,
    this.position,
  );

  final double mass;

  Offset position;

  Offset velocity = Offset.zero;

  Offset force = Offset.zero;

  void clearForces() {
    force = Offset.zero;
  }

  void applyForce(Offset force) {
    this.force += force;
  }

  void update(State change) {
    velocity += change.acceleration;
    position += change.velocity;
  }
}
