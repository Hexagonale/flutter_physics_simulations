import 'dart:ui';

import 'package:physics/physics.dart';

extension OffsetExtensions<T extends Offset> on T {
  Offset rotate90CCW() {
    return Offset(-dy, dx);
  }

  Vector2 get asVector => Vector2(dx, dy);
}
