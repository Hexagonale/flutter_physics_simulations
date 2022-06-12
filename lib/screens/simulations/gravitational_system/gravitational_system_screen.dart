import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import 'models/models.dart';

class GravitationalSystemScreen extends StatefulWidget {
  const GravitationalSystemScreen({Key? key}) : super(key: key);

  @override
  _GravitationalSystemScreenState createState() => _GravitationalSystemScreenState();
}

class _GravitationalSystemScreenState extends State<GravitationalSystemScreen> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _timestamp = ValueNotifier<int>(0);
  late GravitationalSystem _system = _generateOneBodySystem();

  Ticker? _ticker;

  @override
  void initState() {
    super.initState();

    _system.start();

    _ticker = createTicker((_) {
      _timestamp.value = DateTime.now().millisecondsSinceEpoch;
    });
    _ticker!.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _timestamp.dispose();
    _system.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Positioned.fill(
            child: CustomPaint(
              painter: GravitationalSystemDrawer(
                system: _system,
                timestamp: _timestamp,
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
        children: [
          ElevatedButton(
            child: const Text('One body orbiting other'),
            onPressed: () {
              _system.stop();
              _system = _generateOneBodySystem();
              _system.start();

              setState(() {});
            },
          ),
          const SizedBox(width: 16.0),
          ElevatedButton(
            child: const Text('Two body circular orbit'),
            onPressed: () {
              _system.stop();
              _system = _generateTwoBodySystem();
              _system.start();

              setState(() {});
            },
          ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Slider(
              value: _system.simulationSpeed,
              min: 0.01,
              max: 25.0,
              onChanged: (double value) {
                _system.simulationSpeed = value;
                setState(() {});
              },
            ),
          )
        ],
      ),
    );
  }

  GravitationalSystem _generateOneBodySystem() {
    const double m1 = 100000;
    const double m2 = 1;
    const Offset p1 = Offset(0.0, 0.0);
    const Offset p2 = Offset(0.0, -100.0);

    final double distance = (p1 - p2).distance;
    final double v2 = sqrt((GravitationalSystem.gravitationalConstant * m1) / distance);

    return GravitationalSystem(
      objects: <GravitationalObject>[
        GravitationalObject(
          mass: m1,
          position: p1,
          velocity: Offset.zero,
        ),
        GravitationalObject(
          mass: m2,
          position: p2,
          velocity: Offset(-v2, 0.0),
        ),
      ],
    );
  }

  GravitationalSystem _generateTwoBodySystem() {
    const double m1 = 100000;
    const double m2 = 50000;
    const Offset p1 = Offset(0.0, 100.0);
    const Offset p2 = Offset(100.0, -300.0);

    final double distance = (p1 - p2).distance;
    final double denominator = distance * (m1 + m2);
    final double v1 = sqrt(GravitationalSystem.gravitationalConstant * m2 * m2 / denominator);
    final double v2 = sqrt(GravitationalSystem.gravitationalConstant * m1 * m1 / denominator);

    return GravitationalSystem(
      objects: <GravitationalObject>[
        GravitationalObject(
          mass: m1,
          position: p1,
          velocity: Offset(v1, 0.0),
        ),
        GravitationalObject(
          mass: m2,
          position: p2,
          velocity: Offset(-v2, 0.0),
        ),
      ],
    );
  }
}

class GravitationalSystemDrawer extends CustomPainter {
  GravitationalSystemDrawer({
    required this.system,
    required this.timestamp,
  }) : super(repaint: timestamp);

  final GravitationalSystem system;
  final ValueNotifier<int> timestamp;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()..color = const Color(0xff3f3f3f);
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      backgroundPaint,
    );

    canvas.translate(size.width / 2, size.height / 2);
    system.draw(canvas);
  }

  @override
  bool shouldRepaint(covariant GravitationalSystemDrawer oldDelegate) {
    return oldDelegate.system != system || oldDelegate.timestamp.value != timestamp.value;
  }
}
