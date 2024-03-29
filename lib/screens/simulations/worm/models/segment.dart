import 'dart:math';

import 'package:flutter/material.dart';
import 'package:physics/physics.dart';

class Segment {
  Segment({
    required this.tail,
    required this.length,
    double angle = 0,
  }) : head = Vector2(sin(angle), cos(angle)) * length + tail;

  Vector2 head;

  Vector2 tail;

  final double length;

  void follow(Vector2 target, [Segment? child]) {
    final Vector2 connection = target - tail;
    head = target;
    tail = target - connection.withMagnitude(length);

    if (child == null) {
      return;
    }

    final Vector2 currentVector = head - tail;
    final Vector2 childVector = child.head - child.tail;

    final double lengthsProduct = length * child.length;
    final double dotProduct = currentVector.dot(childVector);

    final double angleCos = dotProduct / lengthsProduct;
    final double absoluteAngle = pi - acos(angleCos);

    const double minimumAngle = pi - 0.15;
    if (absoluteAngle < minimumAngle) {
      final double lackingAngle = minimumAngle - absoluteAngle;

      double correctedAngle;
      if (currentVector.dot(childVector.rotate90CCW().asVector) < 0) {
        correctedAngle = currentVector.angle + lackingAngle;
      } else {
        correctedAngle = currentVector.angle - lackingAngle;
      }

      final Vector2 direction = Vector2(cos(correctedAngle), sin(correctedAngle));
      tail = head - direction.withMagnitude(length);
    }
  }

  void draw(Canvas canvas) {
    final Paint paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3.0;

    canvas.drawLine(head, tail, paint);
  }

  @override
  String toString() {
    return 'Segment: $head - $tail';
  }
}
