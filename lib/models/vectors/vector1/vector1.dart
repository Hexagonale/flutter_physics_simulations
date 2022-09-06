import '../_vectors.dart';

class Vector1 implements Vector {
  const Vector1(this.value);

  static const Vector1 zero = Vector1(0);

  final double value;

  @override
  Vector1 copy() {
    return Vector1(value);
  }

  @override
  Vector1 operator +(covariant Vector1 other) {
    return Vector1(value + other.value);
  }

  @override
  Vector1 operator -(covariant Vector1 other) {
    return Vector1(value - other.value);
  }

  @override
  Vector1 operator *(covariant double other) {
    return Vector1(value * other);
  }

  @override
  Vector1 operator /(covariant double other) {
    return Vector1(value / other);
  }

  @override
  Vector1 operator -() {
    return Vector1(-value);
  }

  @override
  Vector1 get normalized => const Vector1(1);
}
