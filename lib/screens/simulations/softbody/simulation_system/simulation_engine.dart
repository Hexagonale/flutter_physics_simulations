import 'dart:async';

import 'package:physics/utils/rk4/rk4_solver.dart';

import 'models/new/_new.dart';

class SimulationEngine {
  SimulationEngine({
    required this.softbodies,
  });

  final Rk4Solver _solver = Rk4Solver();

  final List<Softbody> softbodies;

  Timer? _timer;

  final Stopwatch _deltaStopwatch = Stopwatch();

  void init() {
    _deltaStopwatch.start();

    _timer = Timer.periodic(
      const Duration(microseconds: 50),
      (_) {
        _deltaStopwatch.stop();

        final double delta = _deltaStopwatch.elapsedMicroseconds / 1000 / 1000;
        _update(delta);

        _deltaStopwatch.reset();
        _deltaStopwatch.start();
      },
    );
  }

  void dispose() {
    _timer?.cancel();
  }

  void _update(double delta) {
    for (final Softbody softbody in softbodies) {
      _updateSoftbody(softbody, delta);
    }
  }

  void _updateSoftbody(Softbody softbody, double delta) {
    final List<double> newStates = _solver.solve(
      function: softbody.calculateK,
      initialState: softbody.state,
      delta: delta,
    );

    softbody.update(newStates);
  }
}
