import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import 'models/worm.dart';

class WormScreen extends StatefulWidget {
  const WormScreen({Key? key}) : super(key: key);

  @override
  _WormScreenState createState() => _WormScreenState();
}

class _WormScreenState extends State<WormScreen> {
  final Worm _worm = Worm(1500);
  final ValueNotifier<Offset> _target = ValueNotifier<Offset>(Offset.zero);

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
    _target.value = event.localPosition;
  }

  void _onHover(PointerHoverEvent event) {
    if (event.localPosition == Offset.zero) {
      return;
    }

    _target.value = event.localPosition;
  }
}

class WormDrawer extends CustomPainter {
  WormDrawer({
    required this.worm,
    required this.target,
  }) : super(repaint: target);

  final Worm worm;
  final ValueNotifier<Offset> target;

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
