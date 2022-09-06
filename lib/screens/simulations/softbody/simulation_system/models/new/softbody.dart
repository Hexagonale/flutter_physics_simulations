import 'dart:ui';

import 'package:physics/utils/_utils.dart';

import 'mass_point.dart';
import 'spring.dart';

class Softbody {
  Softbody({
    required this.masses,
    required this.springs,
  }) : massPointIndexes = _generateMassPointIndexes(masses);

  final List<MassPoint> masses;

  final List<Spring> springs;

  final Map<MassPoint, int> massPointIndexes;

  /// Returns list of [x acceleration, y acceleration, x velocity, y velocity] for each point.
  ///
  /// [state] is list of [x velocity, y velocity, x position, y position] for each mass point.
  List<double> calculateK(List<double> state) {
    List<double> output = List.filled(masses.length * 4, 0);

    // Calculate all springs forces.
    for (final Spring spring in springs) {
      final MassPoint a = spring.a;
      final MassPoint b = spring.b;

      final int aIndex = massPointIndexes[a]!;
      final int bIndex = massPointIndexes[b]!;

      final List<double> aState = state.sublist(aIndex * 4, aIndex * 4 + 4);
      final List<double> bState = state.sublist(bIndex * 4, bIndex * 4 + 4);

      Tuple<List<double>> newStates = spring.calculateK(aState, bState);

      for (int i = 0; i < 4; i++) {
        output[aIndex * 4 + i] += newStates.a[i];
        output[bIndex * 4 + i] += newStates.b[i];
      }
    }

    // Calculate all points forces.
    for (int i = 0; i < masses.length; i++) {
      final MassPoint point = masses[i];
      final List<double> massState = state.sublist(i * 4, i * 4 + 4);

      final List<double> newState = point.calculateK(massState);
      for (int j = 0; j < 4; j++) {
        output[i * 4 + j] += newState[j];
      }
    }

    return output;
  }

  void update(List<double> states) {
    for (int i = 0; i < masses.length; i++) {
      final MassPoint point = masses[i];
      final List<double> state = states.sublist(i * 4, i * 4 + 4);

      point.velocity = Offset(state[0], state[1]);
      point.position = Offset(state[2], state[3]);
      point.clearForces();

      if (point.position.dy >= 0.6) {
        point.position = Offset(point.position.dx, 0.6);
        point.velocity = Offset(point.velocity.dx, -point.velocity.dy * 0.4);
      }
    }
  }

  List<double> get state {
    final List<double> states = <double>[];

    for (final MassPoint mass in masses) {
      states.addAll([
        mass.velocity.dx,
        mass.velocity.dy,
        mass.position.dx,
        mass.position.dy,
      ]);
    }

    return states;
  }

  static Map<MassPoint, int> _generateMassPointIndexes(List<MassPoint> points) {
    final Map<MassPoint, int> massPointIndexes = <MassPoint, int>{};

    for (int i = 0; i < points.length; i++) {
      final MassPoint point = points[i];
      massPointIndexes[point] = i;
    }

    return massPointIndexes;
  }
}
