// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'softbody_particle.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoftbodyParticle _$SoftbodyParticleFromJson(Map<String, dynamic> json) =>
    SoftbodyParticle(
      position: json['position'] == null
          ? Offset.zero
          : const OffsetConverter()
              .fromJson(json['position'] as Map<String, dynamic>),
      mass: (json['mass'] as num?)?.toDouble() ?? 0.01,
      floor: (json['floor'] as num?)?.toDouble() ?? 1.0,
      gravity: (json['gravity'] as num?)?.toDouble() ?? 9.8,
    )
      ..velocity = const OffsetConverter()
          .fromJson(json['velocity'] as Map<String, dynamic>)
      ..acceleration = const OffsetConverter()
          .fromJson(json['acceleration'] as Map<String, dynamic>);

Map<String, dynamic> _$SoftbodyParticleToJson(SoftbodyParticle instance) =>
    <String, dynamic>{
      'position': const OffsetConverter().toJson(instance.position),
      'velocity': const OffsetConverter().toJson(instance.velocity),
      'acceleration': const OffsetConverter().toJson(instance.acceleration),
      'mass': instance.mass,
      'floor': instance.floor,
      'gravity': instance.gravity,
    };