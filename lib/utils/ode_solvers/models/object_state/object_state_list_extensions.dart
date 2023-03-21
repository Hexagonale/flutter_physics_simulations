import 'package:physics/physics.dart';

extension ObjectStateListExtensions<T extends Vector, R> on List<ObjectState<T, R>> {
  List<ObjectState<T, R>> sum(List<ObjectState<T, R>> other) {
    final List<ObjectState<T, R>> result = <ObjectState<T, R>>[];

    for (int i = 0; i < length; i++) {
      result.add(this[i] + other[i]);
    }

    return result;
  }

  void sumInPlace(List<ObjectState<T, R>> other) {
    for (int i = 0; i < length; i++) {
      this[i] += other[i];
    }
  }

  void sumInPlaceWithDerivatives(List<ObjectDerivative<T, R>> other, double delta) {
    for (int i = 0; i < length; i++) {
      final ObjectState<T, R> thisState = this[i];
      final ObjectState<T, R> newState = ObjectState<T, R>(
        object: thisState.object,
        velocity: thisState.velocity + other[i].acceleration * delta as T,
        position: thisState.position + other[i].velocity * delta as T,
      );

      this[i] = newState;
    }
  }
}
