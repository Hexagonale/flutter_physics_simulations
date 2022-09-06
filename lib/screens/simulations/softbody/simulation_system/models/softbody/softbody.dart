import 'dart:math';
import 'dart:ui';

import 'package:json_annotation/json_annotation.dart';
import 'package:physics/physics.dart';

import '_softbody.dart';

part 'softbody.g.dart';

@JsonSerializable()
class Softbody {
  Softbody({
    required this.particles,
    required this.connections,
  }) : state = particles
            .map(
              (SoftbodyParticle particle) => State(
                x: particle.position.dx,
                y: particle.position.dy,
                vx: 0,
                vy: 0,
              ),
            )
            .toList();

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

  final List<State> state;

  List<State> getDerivative(List<State> state) {
    final List<State> derivative = [];
    for (final State particleState in state) {
      derivative.add(particleState.copy());
    }

    // Add spring.
    for (int i = 0; i < connections.length; i++) {
      final SoftbodyConnection connection = connections[i];

      final int ai = particles.indexOf(connection.a);
      final int bi = particles.indexOf(connection.b);

      final State a = state[ai];
      final State b = state[bi];

      final Offset aForce = connection.calculateForce(a, b);
      final Offset bForce = -aForce;

      derivative[ai].vx += aForce.dx / connection.a.mass;
      derivative[ai].vy += aForce.dy / connection.a.mass;

      derivative[bi].vx += bForce.dx / connection.b.mass;
      derivative[bi].vy += bForce.dy / connection.b.mass;
    }

    // Add gravity.
    for (int i = 0; i < particles.length; i++) {
      // derivative[i].vy += 0.000000000001;

      derivative[i].x = state[i].vx;
      derivative[i].y = state[i].vy;
    }

    return derivative;
  }

  void updateState(List<State> change) {
    print(change);

    for (int i = 0; i < state.length; i++) {
      state[i] += change[i];

      if (state[i].y > 10.0) {
        state[i].y = 10.0;
        state[i].vy = max(state[i].vy, 0);
      }

      particles[i].position = Vector2(state[i].x, state[i].y);
    }
  }
}

class State {
  State({
    required this.x,
    required this.y,
    required this.vx,
    required this.vy,
  });

  factory State.zero() {
    return State(
      x: 0.0,
      y: 0.0,
      vx: 0.0,
      vy: 0.0,
    );
  }

  double x;

  double y;

  double vx;

  double vy;

  Vector2 get position => Vector2(x, y);

  Vector2 get velocity => Vector2(vx, vy);

  State copy() {
    return State(
      x: x,
      y: y,
      vx: vx,
      vy: vy,
    );
  }

  State operator +(State other) {
    return State(
      x: x + other.x,
      y: y + other.y,
      vx: vx + other.vx,
      vy: vy + other.vy,
    );
  }

  State operator *(double other) {
    return State(
      x: x * other,
      y: y * other,
      vx: vx * other,
      vy: vy * other,
    );
  }

  State operator /(double other) {
    return State(
      x: x / other,
      y: y / other,
      vx: vx / other,
      vy: vy / other,
    );
  }

  @override
  String toString() {
    return 'State(x: $x, y: $y, vx: $vx,vy: $vy)';
  }
}
