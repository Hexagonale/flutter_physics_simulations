import 'package:flutter/material.dart';

import 'euler_simulation.dart';
import 'rk4_simulation.dart';

class TempScreen extends StatefulWidget {
  const TempScreen({Key? key}) : super(key: key);

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> with TickerProviderStateMixin {
  late final Rk4SimulationEngine _rk4Simulation = Rk4SimulationEngine(
    tickerProvider: this,
  );

  late final EulerSimulationEngine _eulerSimulation = EulerSimulationEngine(
    tickerProvider: this,
  );

  @override
  void initState() {
    super.initState();

    _rk4Simulation.init();
    _eulerSimulation.init();
  }

  @override
  void dispose() {
    _rk4Simulation.dispose();
    _eulerSimulation.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: CustomPaint(
          painter: SoftbodyPainter(
            rk4Simulation: _rk4Simulation,
            eulerSimulation: _eulerSimulation,
          ),
        ),
      ),
    );
  }
}

class SoftbodyPainter extends CustomPainter {
  SoftbodyPainter({
    required this.rk4Simulation,
    required this.eulerSimulation,
  }) : super(repaint: eulerSimulation.listenable);

  final Rk4SimulationEngine rk4Simulation;
  final EulerSimulationEngine eulerSimulation;

  @override
  void paint(Canvas canvas, Size size) {
    const double scale = 100.0;

    Paint background = Paint()..color = const Color(0xff333333);
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      background,
    );

    Paint rk4Paint = Paint()
      ..color = const Color(0xffff3333)
      ..strokeWidth = 2;

    canvas.drawLine(rk4Simulation.offset * scale, rk4Simulation.position * scale, rk4Paint);
    canvas.drawCircle(rk4Simulation.position * scale, 10.0, rk4Paint);

    Paint eulerPaint = Paint()
      ..color = const Color(0xff33ff33)
      ..strokeWidth = 2.0;

    canvas.drawLine(eulerSimulation.offset * scale, eulerSimulation.position * scale, eulerPaint);
    canvas.drawCircle(eulerSimulation.position * scale, 10.0, eulerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
