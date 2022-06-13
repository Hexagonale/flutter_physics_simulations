import 'dart:async';
import 'dart:isolate';

import 'package:physics/utils/_utils.dart';

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

  receivePortStream.listen((dynamic message) {
    if (message is! String) {
      return;
    }

    if (message != 'get_softbodies') {
      return;
    }

    sendPort.send(simulationEngine.softbodies);
  });
}
