import 'package:json_annotation/json_annotation.dart';
import 'package:physics/physics.dart';

class Vector2Converter extends JsonConverter<Vector2, Map<String, dynamic>> {
  const Vector2Converter();

  @override
  Vector2 fromJson(Map<String, dynamic> json) {
    final num? x = json['x'];
    final num? y = json['y'];
    if (x == null || y == null) {
      throw '';
    }

    return Vector2(
      x.toDouble(),
      y.toDouble(),
    );
  }

  @override
  Map<String, dynamic> toJson(Vector2 object) {
    return <String, dynamic>{
      'x': object.x,
      'y': object.y,
    };
  }
}
