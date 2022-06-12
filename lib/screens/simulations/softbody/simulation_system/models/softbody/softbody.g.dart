// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'softbody.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Softbody _$SoftbodyFromJson(Map<String, dynamic> json) => Softbody(
      particles: (json['particles'] as List<dynamic>)
          .map((e) => SoftbodyParticle.fromJson(e as Map<String, dynamic>))
          .toList(),
      connections: (json['connections'] as List<dynamic>)
          .map((e) => SoftbodyConnection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SoftbodyToJson(Softbody instance) => <String, dynamic>{
      'particles': instance.particles,
      'connections': instance.connections,
    };
