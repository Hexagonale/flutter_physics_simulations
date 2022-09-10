import 'package:physics/physics.dart';

import 'gravitational_object.dart';

class GravitationalSystem {
  const GravitationalSystem({
    required this.objects,
    this.gravitationalConstant = PhysicsConstants.gravitationalConstantEPlus15,
  });

  final List<GravitationalObject> objects;

  final double gravitationalConstant;
}
