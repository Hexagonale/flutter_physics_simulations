import 'dart:async';
import 'dart:math';
import 'dart:ui';

import 'package:physics/utils/_utils.dart';

import 'rigidbody.dart';

class RigidbodiesSystem {
  RigidbodiesSystem({
    required this.systemElements,
    required this.scale,
    required this.gravitionalConstant,
  });

  final List<Rigidbody> systemElements;
  final double scale;
  final double gravitionalConstant;

  Size? _size;
  Timer? _updateTimer;
  DateTime _lastUpdate = DateTime.now();

  void setSize(Size size) {
    _size = size;
  }

  void start() {
    _updateTimer?.cancel();

    _lastUpdate = DateTime.now();
    _updateTimer = Timer.periodic(
      const Duration(microseconds: 5),
      (_) => update(),
    );
  }

  void stop() {
    _updateTimer?.cancel();
    _updateTimer = null;
  }

  void paint(Canvas canvas) {
    for (final Rigidbody element in systemElements) {
      element.paint(canvas, scale);
    }
  }

  void update() {
    if (_size == null) {
      _lastUpdate = DateTime.now();
      return;
    }

    final double deltaTime = (DateTime.now().microsecondsSinceEpoch - _lastUpdate.microsecondsSinceEpoch) / 1000 / 1000;
    // final double deltaTime = 0.01;
    for (final Rigidbody rigidbody in systemElements) {
      if (rigidbody.position.dy + rigidbody.radius < _size!.height - 0.01 || rigidbody.velocity.dy.abs() > 0.1) {
        rigidbody.applyGravity(gravitionalConstant, deltaTime);
      }

      rigidbody.applyDrag(1.225, deltaTime);
      rigidbody.applyVelocity(deltaTime);
      _updateWallsCollisions(rigidbody);
      _updateCollisions(rigidbody);
    }

    _lastUpdate = DateTime.now();
  }

  void _updateWallsCollisions(Rigidbody element) {
    const double minimalBounceVelocity = 0.1;

    final double downOverflow = element.position.dy + element.radius - _size!.height;
    final double rightOverflow = element.position.dx + element.radius - _size!.width;
    final double upOverflow = -(element.position.dy - element.radius);
    final double leftOverflow = -(element.position.dx - element.radius);

    if (downOverflow > 0) {
      final double clapmedVelocity = element.velocity.dy.clamp(0.0, 1.0);
      final double scaledCOR = element.coefficientOfRestitution * lerpDouble(0.6, 1.0, clapmedVelocity)!;
      final double difference = (downOverflow * scaledCOR);

      if (element.velocity.dy < minimalBounceVelocity) {
        element.velocity = element.velocity.scale(1.0, 0.0);
        element.position = Offset(element.position.dx, _size!.height - element.radius);
      } else {
        element.velocity = element.velocity.scale(1.0, -scaledCOR);
        element.position = Offset(element.position.dx, _size!.height - element.radius - difference);
      }
    }

    if (rightOverflow > 0) {
      final double difference = rightOverflow * element.coefficientOfRestitution;

      if (element.velocity.dx < minimalBounceVelocity) {
        element.velocity = element.velocity.scale(0.0, 1.0);
        element.position = Offset(_size!.width - element.radius, element.position.dy);
      } else {
        element.velocity = element.velocity.scale(-element.coefficientOfRestitution, 1.0);
        element.position = Offset(_size!.width - element.radius - difference, element.position.dy);
      }
    }

    if (upOverflow > 0) {
      final double difference = upOverflow * element.coefficientOfRestitution;

      if (-element.velocity.dy < minimalBounceVelocity) {
        element.velocity = element.velocity.scale(1.0, 0.0);
        element.position = Offset(element.position.dx, element.radius);
      } else {
        element.velocity = element.velocity.scale(1.0, -element.coefficientOfRestitution);
        element.position = Offset(element.position.dx, element.radius + difference);
      }
    }

    if (leftOverflow > 0) {
      final double difference = leftOverflow * element.coefficientOfRestitution;

      if (-element.velocity.dx < minimalBounceVelocity) {
        element.velocity = element.velocity.scale(0.0, 1.0);
        element.position = Offset(element.radius, element.position.dy);
      } else {
        element.velocity = element.velocity.scale(-element.coefficientOfRestitution, 1.0);
        element.position = Offset(element.radius + difference, element.position.dy);
      }
    }
  }

  void updateCollision() {
    _updateCollisions(systemElements.first);
    // for (final Rigidbody rigidbody in systemElements) {
    //   _updateCollisions(rigidbody);
    // }
  }

  void _updateCollisions(Rigidbody rigidbody) {
    for (final Rigidbody other in systemElements) {
      if (rigidbody == other) {
        continue;
      }

      final double distance = (rigidbody.position - other.position).distance.abs();
      double overlap = (rigidbody.radius + other.radius) - distance;
      if (overlap < 0.0) {
        continue;
      }

      // while (overlap > 0.0) {
      //   final double distance = (rigidbody.position - other.position).distance.abs();
      //   overlap = (rigidbody.radius + other.radius) - distance;
      //   if (overlap > 0.0) {
      //     // print('s');
      //     // final double velocityRatio = rigidbody.velocity.distanceSquared / other.velocity.distanceSquared;
      //     // final double rigidbodyBackoff = velocityRatio * overlap;
      //     // final double otherBackoff = overlap - rigidbodyBackoff;
      //     rigidbody.position -= rigidbody.velocity * 0.001;
      //     other.position -= other.velocity * 0.001;
      //   }
      // }

      final Offset collisionTangent = (rigidbody.position - other.position).withMagnitude(1);
      final Offset collisionNormal = collisionTangent.rotate90CCW().withMagnitude(1);

      final double v1n = rigidbody.velocity.dot(collisionNormal);
      final double v1t = rigidbody.velocity.dot(collisionTangent);
      final double v2n = other.velocity.dot(collisionNormal);
      final double v2t = other.velocity.dot(collisionTangent);

      final double m1 = rigidbody.mass;
      final double m2 = other.mass;

      final double sv1np = (v1n * (m1 - m2) + 2 * m2 * v2n) / (m1 + m2);
      final double sv2np = (v2n * (m2 - m1) + 2 * m1 * v1n) / (m1 + m2);

      final Offset v1np = collisionNormal * sv1np;
      final Offset v1tp = collisionTangent * v1t;
      final Offset v2np = collisionNormal * sv2np;
      final Offset v2tp = collisionTangent * v2t;

      final Offset v1 = v1np + v1tp;
      final Offset v2 = v2np + v2tp;

      rigidbody.velocity = v2 * rigidbody.coefficientOfRestitution;
      other.velocity = v1 * other.coefficientOfRestitution;

      // final double overlap = (rigidbody.radius + other.radius) - distance;
      rigidbody.position += rigidbody.velocity.withMagnitude(overlap);
      other.position += other.velocity.withMagnitude(overlap);

      // Now we 'setting' system velocity to the [other].
      // In other words [other] is now our reference point.
      // This allows us to simulate collision as an collision of moving [rigidbody] with stationary [other].
    }
  }
}
