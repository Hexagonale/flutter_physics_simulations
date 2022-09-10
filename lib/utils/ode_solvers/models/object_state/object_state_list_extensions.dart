import 'package:physics/physics.dart';

extension ObjectStateListExtensions<T extends Vector, R> on List<ObjectState<T, R>> {
  List<ObjectState<T, R>> sum(List<ObjectState<T, R>> other) {
    final List<ObjectState<T, R>> result = <ObjectState<T, R>>[];

    for (int i = 0; i < length; i++) {
      result.add(this[i] + other[i]);
    }

    return result;
  }
}
