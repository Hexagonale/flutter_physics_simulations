import 'dart:ui';

import 'segment.dart';

class Worm {
  Worm(int length) {
    final double segmentLength = 500 / length;

    Segment last = Segment(
      length: segmentLength,
      tail: Offset.zero,
    );
    _segments.add(last);

    for (int i = 1; i < length; i++) {
      last = Segment(
        length: segmentLength,
        tail: last.head,
      );

      _segments.add(last);
    }
  }

  final List<Segment> _segments = [];

  void follow(Offset target) {
    _segments.last.follow(target);

    for (int i = _segments.length - 2; i >= 0; i--) {
      _segments[i].follow(_segments[i + 1].tail, _segments[i + 1]);
    }
  }

  void draw(Canvas canvas) {
    for (final Segment segment in _segments) {
      segment.draw(canvas);
    }
  }
}
