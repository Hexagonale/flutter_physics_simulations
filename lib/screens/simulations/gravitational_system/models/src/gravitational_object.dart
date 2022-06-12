import 'dart:ui';

class GravitationalObject {
  GravitationalObject({
    this.mass = 100000,
    this.position = Offset.zero,
    this.velocity = Offset.zero,
  });

  double mass;
  Offset position;
  Offset velocity;

  DateTime? lastUpdate;

  void update(Offset force, double simulationSpeed) {
    lastUpdate ??= DateTime.now();

    final double deltaTime = (DateTime.now().microsecondsSinceEpoch - lastUpdate!.microsecondsSinceEpoch) / 1000 / 1000;
    final double simulatedDeltaTime = deltaTime * 10000 * simulationSpeed;

    final Offset acceleration = force / mass;
    velocity += acceleration * simulatedDeltaTime;
    position += velocity * simulatedDeltaTime;

    lastUpdate = DateTime.now();
  }
}
