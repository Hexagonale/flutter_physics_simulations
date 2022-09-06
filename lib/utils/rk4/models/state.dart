import 'package:physics/physics.dart';

class ObjectState<T extends Vector> {
  const ObjectState({
    required this.velocity,
    required this.position,
  });

  final T velocity;

  final T position;

  ObjectState<T> operator +(ObjectState<T> other) {
    return ObjectState<T>(
      velocity: velocity + other.velocity as T,
      position: position + other.position as T,
    );
  }
}
