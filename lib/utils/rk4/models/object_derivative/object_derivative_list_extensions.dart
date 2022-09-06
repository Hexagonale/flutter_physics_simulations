import 'package:physics/physics.dart';

extension A<T extends Vector> on List<ObjectDerivative<T>> {
  List<ObjectDerivative<T>> operator *(double other) {
    final List<ObjectDerivative<T>> result = <ObjectDerivative<T>>[];

    for (final ObjectDerivative<T> i in this) {
      result.add(i * other);
    }

    return result;
  }

  List<ObjectState<T>> toState(double delta) {
    final List<ObjectState<T>> result = <ObjectState<T>>[];

    for (final ObjectDerivative<T> i in this) {
      result.add(i.toState(delta));
    }

    return result;
  }
}
