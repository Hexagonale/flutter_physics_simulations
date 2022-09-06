import 'package:json_annotation/json_annotation.dart';
import 'package:physics/physics.dart';
import 'package:physics/utils/json_converters/_json_converters.dart';

part 'softbody_particle.g.dart';

@JsonSerializable()
class SoftbodyParticle {
  SoftbodyParticle({
    this.position = Vector2.zero,
    this.mass = 0.01,
    this.floor = 1.0,
    this.gravity = 9.8,
  });

  // region Json

  static SoftbodyParticle fromJson(Map<String, dynamic> json) {
    return _$SoftbodyParticleFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SoftbodyParticleToJson(this);
  }

  // endregion

  @Vector2Converter()
  Vector2 position;

  @Vector2Converter()
  Vector2 velocity = Vector2.zero;

  @Vector2Converter()
  Vector2 acceleration = Vector2.zero;

  double mass;

  double floor;

  double gravity;

  void update(double delta) {
    acceleration += Vector2(0.0, gravity);
    addForce(_dragForce);

    position += velocity * delta;
    velocity += acceleration * delta;

    if (position.dy >= floor) {
      position = Vector2(position.dx, floor);
    }

    acceleration = Vector2.zero;
  }

  void setForce(Vector2 force) {
    acceleration = Vector2(
      force.dx / mass,
      force.dy / mass,
    );
  }

  void addForce(Vector2 force) {
    acceleration += Vector2(
      force.dx / mass,
      force.dy / mass,
    );
  }

  Vector2 get _dragForce {
    if (velocity.distanceSquared == 0) {
      return Vector2.zero;
    }

    return velocity.withMagnitude(velocity.distanceSquared) * -0.01;
  }
}
