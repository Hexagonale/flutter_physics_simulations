import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';

class OffsetConverter extends JsonConverter<Offset, Map<String, dynamic>> {
  const OffsetConverter();

  @override
  Offset fromJson(Map<String, dynamic> json) {
    final num? dx = json['dx'];
    final num? dy = json['dy'];
    if (dx == null || dy == null) {
      throw '';
    }

    return Offset(
      dx.toDouble(),
      dy.toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Offset object) {
    return <String, dynamic>{
      'dx': object.dx,
      'dy': object.dy,
    };
  }
}
