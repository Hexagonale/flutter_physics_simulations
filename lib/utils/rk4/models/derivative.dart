import 'package:physics/physics.dart';

class ObjectDerivative<T extends Vector> {
  const ObjectDerivative({
    required this.acceleration,
    required this.velocity,
  });

  final T acceleration;

  final T velocity;

  ObjectState<T> toState(double delta) {
    return ObjectState<T>(
      velocity: acceleration * delta as T,
      position: velocity * delta as T,
    );
  }

  ObjectDerivative<T> operator +(ObjectDerivative<T> other) {
    return ObjectDerivative<T>(
      acceleration: acceleration + other.acceleration as T,
      velocity: velocity + other.velocity as T,
    );
  }

  ObjectDerivative<T> operator *(double other) {
    return ObjectDerivative<T>(
      acceleration: acceleration * other as T,
      velocity: velocity * other as T,
    );
  }
}
