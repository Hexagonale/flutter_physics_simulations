import 'package:json_annotation/json_annotation.dart';

import '_softbody.dart';

part 'softbody.g.dart';

@JsonSerializable()
class Softbody {
  const Softbody({
    required this.particles,
    required this.connections,
  });

  // region Json

  static Softbody fromJson(Map<String, dynamic> json) {
    return _$SoftbodyFromJson(json);
  }

  Map<String, dynamic> toJson() {
    return _$SoftbodyToJson(this);
  }

  // endregion

  final List<SoftbodyParticle> particles;

  final List<SoftbodyConnection> connections;
}
