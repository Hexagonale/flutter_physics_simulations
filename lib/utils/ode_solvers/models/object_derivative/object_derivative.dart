import 'package:physics/physics.dart';

class ObjectDerivative<T extends Vector, R> {
  const ObjectDerivative({
    required this.acceleration,
    required this.velocity,
    required this.object,
  });

  final T acceleration;

  final T velocity;

  final R object;

  /// Converts these derivatives to states by multiplying them by [delta].
  ObjectState<T, R> toState(double delta) {
    return ObjectState<T, R>(
      velocity: acceleration * delta as T,
      position: velocity * delta as T,
      object: object,
    );
  }

  /// Adds these derivatives to [other].
  ///
  /// Result's [object] is the one from the left side.
  ObjectDerivative<T, R> operator +(ObjectDerivative<T, R> other) {
    return ObjectDerivative<T, R>(
      acceleration: acceleration + other.acceleration as T,
      velocity: velocity + other.velocity as T,
      object: object,
    );
  }

  /// Multiplies these derivatives by [other] number.
  ObjectDerivative<T, R> operator *(double other) {
    return ObjectDerivative<T, R>(
      acceleration: acceleration * other as T,
      velocity: velocity * other as T,
      object: object,
    );
  }
}
