import 'dart:math';
import 'dart:ui';

// TODO(Hexagonale): Add docs.
extension OffsetExtensions on Offset {
  Offset copy() {
    return Offset(dx, dy);
  }

  Offset withMagnitude(double magnitude) {
    final double _distance = distance;
    if (distance == 0) {
      return copy();
    }

    if (magnitude == distance) {
      return copy();
    }

    final double scale = magnitude / _distance;
    return this * scale;
  }

  Offset rotate90CCW() {
    return Offset(-dy, dx);
  }

  double angleBetween(Offset offset) {
    final double lengthsProduct = distanceSquared * offset.distanceSquared;
    final double dotProduct = dot(offset);

    final double angleCos = dotProduct / lengthsProduct;
    return pi - acos(angleCos);
  }

  double dot(Offset offset) {
    return dx * offset.dx + dy * offset.dy;
  }

  void draw(Offset from, Canvas canvas) {
    final Paint paint = Paint()
      ..color = const Color(0xffffffff)
      ..strokeWidth = 5.0;

    canvas.drawLine(from, from + this, paint);
  }

  double get angle {
    return atan2(dy, dx);
  }

  Offset get normalized {
    return withMagnitude(1);
  }

  Offset get squared {
    return Offset(
      dx * dx,
      dy * dy,
    );
  }
}
