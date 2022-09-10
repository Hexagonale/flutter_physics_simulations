import 'package:physics/physics.dart';

class ObjectState<T extends Vector, R> {
  const ObjectState({
    required this.velocity,
    required this.position,
    required this.object,
  });

  final T velocity;

  final T position;

  final R object;

  /// Adds these states to [other].
  ///
  /// Result's [object] is the one from the left side.
  ObjectState<T, R> operator +(ObjectState<T, R> other) {
    return ObjectState<T, R>(
      velocity: velocity + other.velocity as T,
      position: position + other.position as T,
      object: object,
    );
  }
}
