import 'package:physics/physics.dart';

extension A<T extends Vector, R> on List<ObjectDerivative<T, R>> {
  List<ObjectDerivative<T, R>> operator *(double other) {
    final List<ObjectDerivative<T, R>> result = <ObjectDerivative<T, R>>[];

    for (final ObjectDerivative<T, R> i in this) {
      result.add(i * other);
    }

    return result;
  }

  List<ObjectState<T, R>> toState(double delta) {
    final List<ObjectState<T, R>> result = <ObjectState<T, R>>[];

    for (final ObjectDerivative<T, R> i in this) {
      result.add(i.toState(delta));
    }

    return result;
  }
}
