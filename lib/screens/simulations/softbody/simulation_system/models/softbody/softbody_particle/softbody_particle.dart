// import 'dart:ui';

// import 'package:json_annotation/json_annotation.dart';
// import 'package:physics/utils/_utils.dart';
// import 'package:physics/utils/json_converters/offset_converter.dart';

// part 'softbody_particle.g.dart';

// @JsonSerializable()
// class SoftbodyParticle {
//   SoftbodyParticle({
//     this.position = Offset.zero,
//     this.mass = 0.01,
//     this.floor = 1.0,
//     this.gravity = 9.8,
//   });

//   // region Json

//   static SoftbodyParticle fromJson(Map<String, dynamic> json) {
//     return _$SoftbodyParticleFromJson(json);
//   }

//   Map<String, dynamic> toJson() {
//     return _$SoftbodyParticleToJson(this);
//   }

//   // endregion

//   @OffsetConverter()
//   Offset position;

//   @OffsetConverter()
//   Offset velocity = Offset.zero;

//   @OffsetConverter()
//   Offset acceleration = Offset.zero;

//   double mass;

//   double floor;

//   double gravity;

//   void update(double delta) {
//     acceleration += Offset(0.0, gravity);
//     addForce(_dragForce);

//     position += velocity * delta;
//     velocity += acceleration * delta;

//     if (position.dy >= floor) {
//       position = Offset(position.dx, floor);
//     }

//     acceleration = Offset.zero;
//   }

//   void setForce(Offset force) {
//     acceleration = Offset(
//       force.dx / mass,
//       force.dy / mass,
//     );
//   }

//   void addForce(Offset force) {
//     acceleration += Offset(
//       force.dx / mass,
//       force.dy / mass,
//     );
//   }

//   Offset get _dragForce {
//     if (velocity.distanceSquared == 0) {
//       return Offset.zero;
//     }

//     return velocity.withMagnitude(velocity.distanceSquared) * -0.01;
//   }
// }
