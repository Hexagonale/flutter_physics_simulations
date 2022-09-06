import 'package:physics/physics.dart';

class State<T extends Vector> {
  State(this.velocity, this.position);

  final T velocity;

  final T position;
}
