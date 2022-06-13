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
      const Duration(microseconds: 500),
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
    // for (final SoftbodyConnection connection in softbody.connections) {
    //   final Offset force = connection.force;

    //   connection.a.addForce(force);
    //   connection.b.addForce(force * -1.0);
    // }

    // for (final SoftbodyParticle particle in softbody.particles) {
    //   particle.update(delta);
    // }

    // final List<State> initialState = softbody.state;

    // final List<State> dA = softbody.getDerivative(initialState);
    // final List<State> state1 = _simpleUpdateState(initialState, dA, delta / 2);
    // final List<State> dB = softbody.getDerivative(state1);
    // final List<State> state2 = _simpleUpdateState(initialState, dB, delta / 2);
    // final List<State> dC = softbody.getDerivative(state2);
    // final List<State> state3 = _simpleUpdateState(initialState, dC, delta);
    // final List<State> dD = softbody.getDerivative(state3);

    // final List<State> change = List<State>.generate(
    //   initialState.length,
    //   (int _) => State.zero(),
    // );

    // for (int i = 0; i < change.length; i++) {
    //   change[i] = (dA[i] + dB[i] * 2 + dC[i] * 2 + dD[i]) / 6.0 * delta;
    // }

    // softbody.updateState(change);

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
