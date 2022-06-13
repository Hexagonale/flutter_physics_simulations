import 'dart:async';

import 'models/new/_new.dart';

class SimulationEngine {
  SimulationEngine({
    required this.softbodies,
  });

  final List<Softbody> softbodies;

  Timer? _timer;

  DateTime _lastUpdate = DateTime.now();

  void init() {
    _timer = Timer.periodic(
      const Duration(microseconds: 5),
      (_) => _update(_delta),
    );
  }

  void dispose() {
    _timer?.cancel();
  }

  void _update(double delta) {
    for (final Softbody softbody in softbodies) {
      _updateSoftbody(softbody, delta);
    }

    _lastUpdate = DateTime.now();
  }

  void _updateSoftbody(Softbody softbody, double delta) {
    final List<State> k1 = softbody.calculateK(null, 1);
    final List<State> k2 = softbody.calculateK(k1, delta / 2);
    final List<State> k3 = softbody.calculateK(k2, delta / 2);
    final List<State> k4 = softbody.calculateK(k3, delta);

    final List<State> changes = [];
    for (int i = 0; i < k1.length; i++) {
      final State change = (k1[i] + k2[i] * 2 + k3[i] * 2 + k4[i]) * delta / 6.0;

      changes.add(change);
    }

    softbody.update(changes);
  }

  double get _delta {
    final DateTime now = DateTime.now();
    final int differenceMs = now.microsecondsSinceEpoch - _lastUpdate.microsecondsSinceEpoch;

    return differenceMs / 1000 / 1000;
  }
}
