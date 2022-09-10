import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:physics/physics.dart';

import 'models/_models.dart';
import 'simulation/gravitational_simulation.dart';

class GravitationalSystemScreen extends StatefulWidget {
  const GravitationalSystemScreen({Key? key}) : super(key: key);

  @override
  State<GravitationalSystemScreen> createState() => _GravitationalSystemScreenState();
}

class _GravitationalSystemScreenState extends State<GravitationalSystemScreen> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _timestamp = ValueNotifier<int>(0);
  late GravitationalSimulation _simulation = _generateOneBodySimulation();

  Ticker? _ticker;

  double _scale = 0.0000005;
  double _massScale = 0.005;

  @override
  void initState() {
    super.initState();

    _simulation.init();

    _ticker = createTicker((_) {
      _timestamp.value = DateTime.now().millisecondsSinceEpoch;
    });
    _ticker!.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _timestamp.dispose();
    _simulation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: GravitationalSystemDrawer(
                simulation: _simulation,
                timestamp: _timestamp,
                scale: _scale,
                massScale: _massScale,
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: _buildScenarioSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          ElevatedButton(
            child: const Text('One body orbiting other'),
            onPressed: () {
              _simulation.dispose();
              _simulation = _generateOneBodySimulation();
              _simulation.init();

              _scale = 0.0000005;
              _massScale = 0.005;

              setState(() {});
            },
          ),
          const SizedBox(width: 16.0),
          ElevatedButton(
            child: const Text('Two body circular orbit'),
            onPressed: () {
              _simulation.dispose();
              _simulation = _generateTwoBodySimulation();
              _simulation.init();

              _scale = 1;
              _massScale = 0.5;

              setState(() {});
            },
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Slider(
              value: sqrt(_simulation.simulationSpeed).clamp(1.0, 1000.0),
              min: 1.0,
              max: 1000.0,
              onChanged: (double value) {
                _simulation.simulationSpeed = value * value;
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  GravitationalSimulation _generateOneBodySimulation() {
    const double m1 = PhysicsConstants.earthMassEMinus15;
    const double m2 = PhysicsConstants.moonMassEMinus15;
    const Vector2 p1 = Vector2(0.0, 0.0);
    const Vector2 p2 = Vector2(0.0, -385000000);

    const GravitationalObject object1 = GravitationalObject(
      mass: m1,
    );

    const GravitationalObject object2 = GravitationalObject(
      mass: m2,
    );

    const GravitationalSystem system = GravitationalSystem(
      objects: <GravitationalObject>[
        object1,
        object2,
      ],
    );

    final double distance = (p1 - p2).distance;
    final double v2 = sqrt((system.gravitationalConstant * m1) / distance);

    final List<ObjectState<Vector2, GravitationalObject>> states = <ObjectState<Vector2, GravitationalObject>>[
      const ObjectState<Vector2, GravitationalObject>(
        position: p1,
        velocity: Vector2.zero,
        object: object1,
      ),
      ObjectState<Vector2, GravitationalObject>(
        position: p2,
        velocity: Vector2(-v2, 0.0),
        object: object2,
      ),
    ];

    return GravitationalSimulation(
      system: system,
      states: states,
    );
  }

  GravitationalSimulation _generateTwoBodySimulation() {
    const double m1 = 100;
    const double m2 = 50;
    const Vector2 p1 = Vector2(0.0, 100.0);
    const Vector2 p2 = Vector2(100.0, -300.0);

    const GravitationalObject object1 = GravitationalObject(
      mass: m1,
    );

    const GravitationalObject object2 = GravitationalObject(
      mass: m2,
    );

    const GravitationalSystem system = GravitationalSystem(
      objects: <GravitationalObject>[
        object1,
        object2,
      ],
    );

    final double distance = (p1 - p2).distance;
    final double denominator = distance * (m1 + m2);
    final double v1 = sqrt(system.gravitationalConstant * m2 * m2 / denominator);
    final double v2 = sqrt(system.gravitationalConstant * m1 * m1 / denominator);

    final List<ObjectState<Vector2, GravitationalObject>> states = <ObjectState<Vector2, GravitationalObject>>[
      ObjectState<Vector2, GravitationalObject>(
        position: p1,
        velocity: Vector2(v1, 0.0),
        object: object1,
      ),
      ObjectState<Vector2, GravitationalObject>(
        position: p2,
        velocity: Vector2(-v2, 0.0),
        object: object2,
      ),
    ];

    return GravitationalSimulation(
      system: system,
      states: states,
    );
  }
}

class GravitationalSystemDrawer extends CustomPainter {
  GravitationalSystemDrawer({
    required this.simulation,
    required this.timestamp,
    required this.scale,
    required this.massScale,
  }) : super(repaint: timestamp);

  final GravitationalSimulation simulation;
  final ValueNotifier<int> timestamp;
  final double scale;
  final double massScale;

  late final double _minimalRadius = 10 / scale;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(scale);
    size /= scale;

    final Paint backgroundPaint = Paint()..color = const Color(0xff3f3f3f);
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      backgroundPaint,
    );

    canvas.translate(size.width / 2, size.height / 2);

    final Paint objectPaint = Paint()..color = const Color(0xffff5555);

    final Vector2 massCenter = simulation.massCenter;
    canvas.translate(-massCenter.dx, -massCenter.dy);
    canvas.drawCircle(massCenter, 5.0 / scale, Paint()..color = const Color(0xffffffff));

    for (final ObjectState<Vector2, GravitationalObject> state in simulation.states) {
      final double radius = state.object.mass * massScale;

      canvas.drawCircle(state.position, max(radius, _minimalRadius), objectPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GravitationalSystemDrawer oldDelegate) {
    return oldDelegate.simulation != simulation || oldDelegate.timestamp.value != timestamp.value;
  }
}
