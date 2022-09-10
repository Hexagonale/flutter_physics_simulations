import 'package:physics/physics.dart';

import '_models.dart';

class GravitationalSimulationSetup {
  const GravitationalSimulationSetup({
    required this.name,
    required this.gravitationalSystem,
    required this.states,
    required this.scale,
    required this.massScale,
    required this.minSpeed,
    required this.maxSpeed,
    required this.initialSpeed,
  });

  final String name;

  final GravitationalSystem gravitationalSystem;

  final List<ObjectState<Vector2, GravitationalObject>> states;

  final double scale;

  final double massScale;

  final double minSpeed;

  final double maxSpeed;

  final double initialSpeed;
}
