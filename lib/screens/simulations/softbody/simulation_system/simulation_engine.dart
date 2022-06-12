import 'dart:async';

import 'package:flutter/material.dart';

import 'models/_models.dart';

class SimulationEngine {
  SimulationEngine({
    required this.softbodies,
  });

  final List<Softbody> softbodies;

  Timer? _timer;

  DateTime _lastUpdate = DateTime.now();

  void init() {
    _timer = Timer.periodic(
      const Duration(microseconds: 1),
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
    for (final SoftbodyConnection connection in softbody.connections) {
      final Offset force = connection.force;

      connection.a.addForce(force);
      connection.b.addForce(force * -1.0);
    }

    for (final SoftbodyParticle particle in softbody.particles) {
      particle.update(delta);
    }
  }

  double get _delta {
    final DateTime now = DateTime.now();
    final int differenceMs = now.microsecondsSinceEpoch - _lastUpdate.microsecondsSinceEpoch;

    return differenceMs / 1000 / 1000;
  }
}
