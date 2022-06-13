import 'dart:math';
import 'dart:ui';

import 'mass_point.dart';
import 'spring.dart';

class Softbody {
  Softbody({
    required this.masses,
    required this.springs,
  });

  final List<MassPoint> masses;

  final List<Spring> springs;

  void update(double delta) {
    for (final Spring spring in springs) {
      spring.update(delta);
    }

    for (final MassPoint point in masses) {
      // point.applyForce(Offset(
      //   0.0,
      //   9.8 * point.mass,
      // ));

      point.update(delta);
      point.clearForces();

      if (point.position.dy >= 1.0) {
        point.position = Offset(point.position.dx, 1.0);
        point.velocity = Offset(point.velocity.dx, max(point.velocity.dy, 0));
      }
    }
  }
}
