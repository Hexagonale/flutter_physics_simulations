import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:physics/physics.dart';

import 'models/worm.dart';

class WormScreen extends StatefulWidget {
  const WormScreen({super.key});

  @override
  State<WormScreen> createState() => _WormScreenState();
}

class _WormScreenState extends State<WormScreen> {
  final Worm _worm = Worm(1500);
  final ValueNotifier<Vector2> _target = ValueNotifier<Vector2>(Vector2.zero);

  @override
  void dispose() {
    _target.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: MouseRegion(
        onEnter: _onEnter,
        onHover: _onHover,
        child: SizedBox(
          height: double.infinity,
          width: double.infinity,
          child: CustomPaint(
            painter: WormDrawer(
              worm: _worm,
              target: _target,
            ),
          ),
        ),
      ),
    );
  }

  void _onEnter(PointerEnterEvent event) {
    _target.value = event.localPosition.asVector;
  }

  void _onHover(PointerHoverEvent event) {
    if (event.localPosition == Offset.zero) {
      return;
    }

    _target.value = event.localPosition.asVector;
  }
}

class WormDrawer extends CustomPainter {
  WormDrawer({
    required this.worm,
    required this.target,
  }) : super(repaint: target);

  final Worm worm;
  final ValueNotifier<Vector2> target;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint backgroundPaint = Paint()..color = const Color(0xff3f3f3f);
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      backgroundPaint,
    );

    worm.follow(target.value);
    worm.draw(canvas);
  }

  @override
  bool shouldRepaint(covariant WormDrawer oldDelegate) {
    return oldDelegate.worm != worm || oldDelegate.target.value != target.value;
  }
}
