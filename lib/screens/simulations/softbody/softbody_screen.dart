import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:physics/physics.dart';

import 'simulation_system/models/new/_new.dart';
import 'simulation_system/softbody_simulation.dart';

class SoftbodyScreen extends StatefulWidget {
  const SoftbodyScreen({Key? key}) : super(key: key);

  @override
  State<SoftbodyScreen> createState() => _SoftbodyScreenState();
}

class _SoftbodyScreenState extends State<SoftbodyScreen> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _timestamp = ValueNotifier<int>(0);
  late final SoftbodySimulation _softbodySimulation = SoftbodySimulation.build();

  Ticker? _ticker;

  @override
  void initState() {
    super.initState();

    _softbodySimulation.init();

    _ticker = createTicker((_) {
      _timestamp.value = DateTime.now().millisecondsSinceEpoch;
    });
    _ticker!.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _timestamp.dispose();
    _softbodySimulation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
          // onTap: () => _softbody.reset(),
          onTapDown: (_) => _softbodySimulation.applyForce(),
          onTapUp: (_) => _softbodySimulation.clearForce(),
          onSecondaryTap: () => _softbodySimulation.applyForce(),
          // onPanUpdate: _onDragUpdate,
          // onPanEnd: _onDragEnd,
          child: CustomPaint(
            painter: SoftbodyPainter(
              timestamp: _timestamp,
              softbody: _softbodySimulation,
            ),
          ),
        ),
      ),
    );
  }
}

class SoftbodyPainter extends CustomPainter {
  SoftbodyPainter({
    required this.timestamp,
    required this.softbody,
  }) : super(repaint: timestamp);

  final ValueNotifier<int> timestamp;
  final SoftbodySimulation softbody;

  @override
  void paint(Canvas canvas, Size size) {
    const double scale = 1000.0;

    final Paint background = Paint()..color = const Color(0xff333333);
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      background,
    );

    final Random random = Random(1);
    for (final ObjectState<Vector2, MassPoint> state in softbody.states) {
      final Paint paint = Paint()
        ..color = Color.fromRGBO(
          random.nextInt(255),
          random.nextInt(255),
          random.nextInt(255),
          1.0,
        );

      canvas.drawCircle(state.position * scale, 5.0, paint);
    }

    // for (final Tuple<Offset> connection in softbody.connections) {
    //   final Offset linkVector = (connection.a - connection.b);
    //   final double currentDistance = linkVector.distance;
    //   final double difference = 1.5 - currentDistance;
    //   final double opacity = 1.0 * difference.abs() / 1.5 + 0.5;

    //   final Paint paint = Paint()
    //     ..color = Color.fromRGBO(255, 255, 255, min(opacity, 1.0))
    //     ..strokeWidth = 2.0;

    //   canvas.drawLine(
    //     connection.a * scale,
    //     connection.b * scale,
    //     paint,
    //   );
    // }

    // final Paint paint = Paint()
    //   ..color = Colors.white
    //   ..strokeWidth = 2.0;

    // canvas.drawLine(const Offset(0.0, 900.0), Offset(size.width, 900.0), paint);
    // canvas.drawLine(const Offset(0.0, 1000.0), Offset(size.width, 1000.0), paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
