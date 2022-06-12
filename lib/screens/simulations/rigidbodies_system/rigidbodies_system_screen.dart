import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:physics/utils/_utils.dart';

import 'models/rigidbodies_system.dart';
import 'models/rigidbody.dart';

class RigidbodiesSystemScreen extends StatefulWidget {
  const RigidbodiesSystemScreen({Key? key}) : super(key: key);

  @override
  _RigidbodiesSystemScreenState createState() => _RigidbodiesSystemScreenState();
}

class _RigidbodiesSystemScreenState extends State<RigidbodiesSystemScreen> with SingleTickerProviderStateMixin {
  static const double _scale = 200;

  // final RigidbodiesSystem _system = RigidbodiesSystem(
  //   scale: _scale,
  //   gravitionalConstant: 9.8,
  //   systemElements: <Rigidbody>[
  //     Rigidbody(
  //       dragCoefficient: 0.5,
  //       mass: 1.0,
  //       position: const Offset(2, 0.5),
  //       radius: 0.15,
  //       coefficientOfRestitution: 0.92,
  //     ),
  //     Rigidbody(
  //       dragCoefficient: 0.5,
  //       mass: 1.0,
  //       position: const Offset(1, 0.5),
  //       radius: 0.15,
  //       coefficientOfRestitution: 0.92,
  //     ),
  //   ],
  // );
  final RigidbodiesSystem _system = RigidbodiesSystem(
    scale: _scale,
    gravitionalConstant: 9.8,
    systemElements: List.generate(
      1,
      (int i) => Rigidbody(
        dragCoefficient: 0.5,
        mass: 1.0,
        position: Offset(i * 0.4 + 1, 0.5),
        radius: 0.15,
        coefficientOfRestitution: 0.92,
      ),
    ),
  );

  Ticker? _ticker;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((_) => setState(() {}));
    _ticker!.start();

    // _system.start();
    // _system.stop();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _system.stop();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        height: double.infinity,
        child: GestureDetector(
          onTapDown: (_) => _system.update(),
          onTapUp: (_) => _system.updateCollision(),
          onSecondaryTap: () => _system.start(),
          onPanUpdate: _onDragUpdate,
          onPanEnd: _onDragEnd,
          child: CustomPaint(
            painter: SystemPainter(
              system: _system,
              scale: _scale,
            ),
          ),
        ),
      ),
    );
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _system.stop();
    _system.systemElements.first.position = details.localPosition / _scale;
  }

  void _onDragEnd(DragEndDetails details) {
    final Rigidbody element = _system.systemElements.first;
    element.velocity = details.velocity.pixelsPerSecond / _scale;
    _system.start();
  }
}

class SystemPainter extends CustomPainter {
  SystemPainter({
    required this.system,
    required this.scale,
  });

  final RigidbodiesSystem system;
  final double scale;

  @override
  void paint(Canvas canvas, Size size) {
    final Size scaledSize = size / scale;
    system.setSize(scaledSize);

    Paint background = Paint()..color = const Color(0xff333333);
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height), background);

    final Rigidbody element = system.systemElements.first;
    final double height = scaledSize.height - element.position.dy - element.radius;
    final double potentialEnergy = height * element.mass * system.gravitionalConstant;
    final double kineticEnergy = element.velocity.distanceSquared * element.mass / 2;

    final Paint line = Paint()..color = Colors.white;
    canvas.drawRect(Rect.fromLTWH(0.0, 0.0, potentialEnergy * 10.0, 30.0), line);
    canvas.drawRect(Rect.fromLTWH(0.0, 50.0, kineticEnergy * 10.0, 30.0), line);
    canvas.drawRect(Rect.fromLTWH(0.0, 100.0, (potentialEnergy + kineticEnergy) * 10.0, 30.0), line);

    system.paint(canvas);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
