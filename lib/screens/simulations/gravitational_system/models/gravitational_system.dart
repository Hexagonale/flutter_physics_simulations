import 'gravitational_object.dart';

class GravitationalSystem {
  const GravitationalSystem({
    required this.objects,
    this.gravitationalConstant = 6.67408 * 0.00000001,
  });

  final List<GravitationalObject> objects;

  final double gravitationalConstant;
}
