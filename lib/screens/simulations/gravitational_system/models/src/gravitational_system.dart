import 'dart:async';
import 'dart:ui';

import 'package:physics/utils/_utils.dart';

import 'gravitational_object.dart';

class GravitationalSystem {
  static const double gravitationalConstant = 6.67408 * 0.00000001;

  GravitationalSystem({
    this.objects = const [],
    this.simulationSpeed = 1.0,
  });

  final List<GravitationalObject> objects;
  double simulationSpeed;

  Timer? _updateTimer;

  void start() {
    _updateTimer = Timer.periodic(const Duration(microseconds: 2), (_) {
      _update();
    });
  }

  void stop() {
    _updateTimer?.cancel();
  }

  void _update() {
    final List<Offset> forces = <Offset>[];

    for (final GravitationalObject object in objects) {
      forces.add(_updateObject(object));
    }

    for (int i = 0; i < objects.length; i++) {
      objects[i].update(forces[i], simulationSpeed);
    }
  }

  void draw(Canvas canvas) {
    const double massConstant = 0.0003;
    final Paint objectPaint = Paint()..color = const Color(0xffff5555);

    Offset massCenter = Offset.zero;
    double massesSum = 0.0;
    for (final GravitationalObject object in objects) {
      massCenter += object.position * object.mass;
      massesSum += object.mass;
    }
    massCenter /= massesSum;
    canvas.translate(-massCenter.dx, -massCenter.dy);

    for (final GravitationalObject object in objects) {
      final double radius = object.mass * massConstant;

      canvas.drawCircle(object.position, radius < 10.0 ? 10.0 : radius, objectPaint);
    }

    canvas.drawCircle(massCenter, 5.0, Paint()..color = const Color(0xffffffff));
  }

  Offset _updateObject(GravitationalObject object) {
    Offset forcesSum = Offset.zero;

    for (final GravitationalObject relative in objects) {
      if (relative == object) {
        continue;
      }

      final Offset gravityVector = relative.position - object.position;
      final double distanceSquared = gravityVector.distanceSquared;
      if (distanceSquared < 1) {
        forcesSum += gravityVector.withMagnitude(0.001);

        continue;
      }

      final double forceMagnitude = (gravitationalConstant * relative.mass * object.mass) / distanceSquared;
      final Offset force = gravityVector.withMagnitude(forceMagnitude);

      forcesSum += force;
    }

    return forcesSum;
  }
}
