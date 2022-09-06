// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'softbody_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SoftbodyConnection _$SoftbodyConnectionFromJson(Map<String, dynamic> json) =>
    SoftbodyConnection(
      a: SoftbodyParticle.fromJson(json['a'] as Map<String, dynamic>),
      b: SoftbodyParticle.fromJson(json['b'] as Map<String, dynamic>),
      stiffness: (json['stiffness'] as num?)?.toDouble() ?? 32500.0,
      damping: (json['damping'] as num?)?.toDouble() ?? 10.0,
    );

Map<String, dynamic> _$SoftbodyConnectionToJson(SoftbodyConnection instance) =>
    <String, dynamic>{
      'a': instance.a,
      'b': instance.b,
      'stiffness': instance.stiffness,
      'damping': instance.damping,
    };
