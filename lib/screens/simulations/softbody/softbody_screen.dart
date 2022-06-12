import 'dart:math';

import 'package:flutter/material.dart';
import 'package:physics/utils/_utils.dart';

import 'simulation_system/softbody_simulation.dart';

class SoftbodyScreen extends StatefulWidget {
  const SoftbodyScreen({Key? key}) : super(key: key);

  @override
  State<SoftbodyScreen> createState() => _SoftbodyScreenState();
}

class _SoftbodyScreenState extends State<SoftbodyScreen> with SingleTickerProviderStateMixin {
  late final SoftbodySimulation _softbodySimulation = SoftbodySimulation(
    tickerProvider: this,
  );

  @override
  void initState() {
    super.initState();

    _softbodySimulation.init();
  }

  @override
  void dispose() {
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
          // onTapDown: (_) => _system.update(),
          // onTapUp: (_) => _system.updateCollision(),
          // onSecondaryTap: () => _softbody.test(),
          // onPanUpdate: _onDragUpdate,
          // onPanEnd: _onDragEnd,
          child: CustomPaint(
            painter: SoftbodyPainter(
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
    required this.softbody,
  }) : super(repaint: softbody.notifier);

  final SoftbodySimulation softbody;

  @override
  void paint(Canvas canvas, Size size) {
    const double scale = 1000.0;

    Paint background = Paint()..color = const Color(0xff333333);
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      background,
    );

    final Random random = Random(1);
    for (final Offset position in softbody.notifier.value) {
      final Paint paint = Paint()
        ..color = Color.fromRGBO(
          random.nextInt(255),
          random.nextInt(255),
          random.nextInt(255),
          1.0,
        );

      canvas.drawCircle(position * scale, 5.0, paint);
    }

    for (final Tuple<Offset> connection in softbody.connections) {
      final Offset linkVector = (connection.a - connection.b);
      final double currentDistance = linkVector.distance;
      final double difference = 1.5 - currentDistance;
      final double opacity = 1.0 * difference.abs() / 1.5 + 0.5;

      final Paint paint = Paint()
        ..color = Color.fromRGBO(255, 255, 255, min(opacity, 1.0))
        ..strokeWidth = 2.0;

      canvas.drawLine(
        connection.a * scale,
        connection.b * scale,
        paint,
      );
    }

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
