import 'dart:math';
import 'dart:ui';

import '../_vectors.dart';

class Vector2 extends Offset implements Vector {
  const Vector2(super.dx, super.dy);

  const Vector2.all(double all) : this(all, all);

  static const Vector2 zero = Vector2.all(0.0);

  @override
  Vector2 copy() {
    return Vector2(x, y);
  }

  Vector2 withMagnitude(double magnitude) {
    final double distanceMemo = distance;
    if (distanceMemo == 0) {
      return copy();
    }

    if (magnitude == distanceMemo) {
      return copy();
    }

    final double scale = magnitude / distanceMemo;
    return this * scale;
  }

  double dot(Vector2 other) {
    return x * other.x + y * other.y;
  }

  double angleTo(Vector2 other) {
    final double lengthsProduct = distanceSquared * other.distanceSquared;
    final double dotProduct = dot(other);

    final double angleCos = dotProduct / lengthsProduct;
    return pi - acos(angleCos);
  }

  @override
  Vector2 operator +(covariant Vector2 other) {
    return Vector2(
      x + other.x,
      y + other.y,
    );
  }

  @override
  Vector2 operator -(covariant Vector2 other) {
    return Vector2(
      x - other.x,
      y - other.y,
    );
  }

  @override
  Vector2 operator *(covariant double operand) {
    return Vector2(
      x * operand,
      y * operand,
    );
  }

  @override
  Vector2 operator /(covariant double operand) {
    return Vector2(
      x / operand,
      y / operand,
    );
  }

  @override
  Vector2 operator -() {
    return Vector2(-x, -y);
  }

  double get x => dx;

  double get y => dy;

  @override
  Vector2 get normalized {
    return withMagnitude(1);
  }

  double get angle {
    return atan2(dy, dx);
  }
}
