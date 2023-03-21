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

  int i = 1;
  int solveTimeUsSum = 0;
  int deltaUsSum = 0;

  double solveTimeUs = 0;
  double deltaUs = 0;

  @override
  void paint(Canvas canvas, Size size) {
    solveTimeUsSum += softbody.solveTimeUs;
    deltaUsSum += softbody.deltaUs;

    if (i++ % 61 == 0) {
      solveTimeUs = solveTimeUsSum / i;
      deltaUs = deltaUsSum / i;

      solveTimeUsSum = 0;
      deltaUsSum = 0;
      i = 1;
    }

    const double scale = 350.0;

    canvas.drawColor(const Color(0xff333333), BlendMode.src);

    final Paint legend = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke;
    canvas.drawRect(
      const Rect.fromLTWH(300.0, 300.0, 1.0 * scale, 1.0 * scale),
      legend,
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

    final TextSpan span = TextSpan(
      style: const TextStyle(color: Colors.white),
      text: 'Solve time: ${solveTimeUs}uS\n'
          'Delta time: ${deltaUs}uS\n'
          'Usage: ${(solveTimeUs / (deltaUs + solveTimeUs) * 100).toStringAsFixed(2)}%',
    );
    final TextPainter textPainter = TextPainter(
      text: span,
      textAlign: TextAlign.left,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout();
    textPainter.paint(canvas, const Offset(5.0, 5.0));

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
