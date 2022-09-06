import 'dart:async';
import 'dart:isolate';
import 'dart:math';

import 'package:physics/physics.dart';

import 'models/new/_new.dart';
import 'simulation_engine.dart';

class PhysicsIsolate {
  PhysicsIsolate({
    required this.initialSoftbodies,
  });

  final List<Softbody> initialSoftbodies;

  final ReceivePort _receivePort = ReceivePort();

  late final Stream<dynamic> _receivePortStream = _receivePort.asBroadcastStream();

  SendPort? _controlPort;

  Isolate? _isolate;

  StreamSubscription? _subscription;

  Future<void> init() async {
    _isolate = await Isolate.spawn(
      _entry,
      _receivePort.sendPort,
    );

    _controlPort = await _receivePortStream.safeFirst();
    if (_controlPort == null) {
      return;
    }

    _controlPort!.send(initialSoftbodies);
  }

  void dispose() {
    _subscription?.cancel();
    _isolate?.kill();
    _receivePort.close();
  }

  Future<List<Softbody>?> getSoftbodies() async {
    _controlPort?.send('get_softbodies');

    final List<Softbody>? softbodies = await _receivePortStream.safeFirst();
    if (softbodies == null) {
      return null;
    }

    return softbodies;
  }

  void applyForce(double force) {
    _controlPort?.send('apply_force#$force');
  }
}

Future<void> _entry(SendPort sendPort) async {
  final ReceivePort receivePort = ReceivePort();
  final Stream<dynamic> receivePortStream = receivePort.asBroadcastStream();

  sendPort.send(receivePort.sendPort);

  final List<Softbody>? softbodies = await receivePortStream.safeFirst();
  if (softbodies == null) {
    return;
  }

  final SimulationEngine simulationEngine = SimulationEngine(
    softbodies: softbodies,
  );

  simulationEngine.init();

  receivePortStream.listen((dynamic message) async {
    if (message is! String) {
      return;
    }

    if (message == 'get_softbodies') {
      sendPort.send(simulationEngine.softbodies);
    }

    if (message.startsWith('apply_force')) {
      final String force = message.split('#')[1];
      final double? forceParsed = double.tryParse(force);
      if (forceParsed == null) {
        return;
      }

      final int width = sqrt(softbodies[0].masses.length).round();
      for (int i = 0; i < 16; i++) {
        for (int yi = (width * 0.6).round(); yi < width; yi++) {
          for (int xi = (width * 0.6).round(); xi < width; xi++) {
            final int index = yi * width + xi;
            softbodies[0].masses[index].applyForce(Vector2(0.0, forceParsed));
          }
        }

        await Future.delayed(const Duration(milliseconds: 10));
      }
    }
  });
}
