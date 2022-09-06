import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:physics/utils/_utils.dart';

import '../_softbody.dart';

part 'softbody_connection.g.dart';

@JsonSerializable()
class SoftbodyConnection {
  SoftbodyConnection({
    required this.a,
    required this.b,
    this.stiffness = 32500.0,
    this.damping = 10.0,
  }) : length = (b.position - a.position).distance;

  // region Json

  static SoftbodyConnection fromJson(Map<String, dynamic> json) {
    return _$SoftbodyConnectionFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SoftbodyConnectionToJson(this);
  }

  // endregion

  final SoftbodyParticle a;

  final SoftbodyParticle b;

  final double stiffness;

  final double damping;

  final double length;

  Offset calculateForce(State a, State b) {
    final Offset currentVector = b.position - a.position;
    // final bool inverted = currentVector.direction != vector.direction;
    final double difference = length - currentVector.distance;
    final Offset force = currentVector.withMagnitude(difference * -stiffness);

    return force + _calculateDrag(a, b);
  }

  Offset _calculateDrag(State a, State b) {
    final Offset vector = (b.position - a.position).normalized;
    final Offset velocityDifference = b.velocity - a.velocity;
    final double dot = vector.dot(velocityDifference);

    return vector * dot * damping;
  }

  // Offset get force {
  //   final Offset currentVector = vector;
  //   // final bool inverted = currentVector.direction != vector.direction;
  //   final double difference = length - currentVector.distance;
  //   final Offset force = currentVector.withMagnitude(difference * -stiffness);

  //   return force + _drag;
  // }

  // Offset get vector {
  //   return b.position - a.position;
  // }

  // Offset get _drag {
  //   final Offset vector = (b.position - a.position).normalized;
  //   final Offset velocityDifference = b.velocity - a.velocity;
  //   final double dot = vector.dot(velocityDifference);

  //   return vector * dot * damping;
  // }
}