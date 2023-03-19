import 'dart:ui';

import 'package:physics/physics.dart';

extension OffsetExtensions<T extends Offset> on T {
  Offset rotate90CCW() {
    return Offset(-dy, dx);
  }

  void draw(Offset from, Canvas canvas) {
    final Paint paint = Paint()
      ..color = const Color(0xffffffff)
      ..strokeWidth = 5.0;

    canvas.drawLine(from, from + this, paint);
  }

  Vector2 get asVector => Vector2(dx, dy);

  Offset get squared {
    return Offset(
      dx * dx,
      dy * dy,
    );
  }
}
