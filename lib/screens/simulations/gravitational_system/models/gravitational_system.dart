import 'package:physics/physics.dart';

import 'gravitational_object.dart';

class GravitationalSystem {
  const GravitationalSystem({
    required this.objects,
    this.gravitationalConstant = PhysicsConstants.gravitationalConstant,
  });

  final List<GravitationalObject> objects;

  final double gravitationalConstant;
}
