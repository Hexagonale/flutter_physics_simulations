import 'dart:ui';
import 'package:physics/utils/_utils.dart';

class Rigidbody {
  Rigidbody({
    required this.mass,
    required this.radius,
    required this.position,
    required this.dragCoefficient,
    required this.coefficientOfRestitution,
  });

  final double mass;
  final double radius;
  final double dragCoefficient;
  final double coefficientOfRestitution;

  Offset position;
  Offset velocity = Offset.zero;

  void paint(Canvas canvas, double scale) {
    final Paint paint = Paint()..color = const Color(0xffff0000);

    canvas.drawCircle(position * scale, radius * scale, paint);
    (velocity * scale).draw(position * scale, canvas);
  }

  void applyGravity(double gravity, double deltaTime) {
    final Offset gravityAcceleration = Offset(0.0, gravity);

    velocity += gravityAcceleration * deltaTime;
  }

  void applyDrag(double density, double deltaTime) {
    final double area = radius * 2;
    final double dragMagnitude = -velocity.distanceSquared * dragCoefficient * density * area / 2;
    final Offset dragForce = velocity.withMagnitude(dragMagnitude);
    final Offset dragAcceleration = dragForce / mass;

    velocity += dragAcceleration * deltaTime;
  }

  void applyVelocity(double deltaTime) {
    position += velocity * deltaTime;
  }

  // GETTERS

  double get momentum {
    return velocity.distanceSquared * mass / 2;
  }
}
