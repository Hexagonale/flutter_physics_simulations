import 'dart:ui';

import 'package:physics/utils/_utils.dart';

import 'mass_point.dart';

class Spring {
  Spring({
    required this.a,
    required this.b,
    this.stiffness = 10000.5,
    this.damping = 10.5,
  }) : initialLength = (a.position - b.position).distance;

  final MassPoint a;

  final MassPoint b;

  final double stiffness;

  final double damping;

  final double initialLength;

  State getDerivativeAtTime(State initialState, double delta, State derivative) {
    // final State stateNew = State();
    // stateNew.ax = initialState.ax + derivative.ax;
    // stateNew.ay = initialState.ay + derivative.ay;
    // stateNew.avx = initialState.avx + derivative.avx;
    // stateNew.avy = initialState.avy + derivative.avy;

    // stateNew.bx = initialState.bx + derivative.bx;
    // stateNew.by = initialState.by + derivative.by;
    // stateNew.bvx = initialState.bvx + derivative.bvx;
    // stateNew.bvy = initialState.bvy + derivative.bvy;

    final State output = State();
    // output.ax = stateNew.avx;
    // output.ay = stateNew.avy;

    // output.ax = stateNew.avx;
    // output.ay = stateNew.avy;

    // applyAccel(stateNew, output);

    return output;
  }

  void applyAccel(State state, State toFill) {
    // final Offset force = calculateForce(state);

    // toFill.avx = force.dx / a.mass;
    // toFill.avy = force.dy / a.mass;

    // toFill.bvx = (-force).dx / b.mass;
    // toFill.bvy = (-force).dy / b.mass;
  }

  Offset _calculateForce(Offset posA, Offset posB, Offset velA, Offset velB) {
    final Offset currentVector = posB - posA;
    // final bool inverted = currentVector.direction != vector.direction;
    final double difference = initialLength - currentVector.distance;
    final Offset force = currentVector.withMagnitude(difference * -stiffness);

    return force + _calculateDrag(posA, posB, velA, velB);
  }

  Offset _calculateDrag(Offset posA, Offset posB, Offset velA, Offset velB) {
    final Offset vector = (posB - posA).normalized;
    final Offset velocityDifference = velB - velA;
    final double dot = vector.dot(velocityDifference);

    return vector * dot * damping;
  }

  Tuple<State> _calculateK(State a, State b, double delta) {
    final Offset newPositionA = this.a.position + a.velocity * delta;
    final Offset newPositionB = this.b.position + b.velocity * delta;

    final Offset forceA = _calculateForce(newPositionA, newPositionB, a.velocity, b.velocity);
    final Offset forceB = -forceA;

    final Offset accelerationA = forceA / this.a.mass + const Offset(0.0, 9.8);
    final Offset accelerationB = forceB / this.b.mass + const Offset(0.0, 9.8);

    final Offset velocityA = this.a.velocity + a.acceleration * delta;
    final Offset velocityB = this.b.velocity + b.acceleration * delta;

    return Tuple(
      State.fromVelocityAndAcceleration(velocityA, accelerationA),
      State.fromVelocityAndAcceleration(velocityB, accelerationB),
    );
  }

  void update(double delta) {
    final Tuple<State> k1 = _calculateK(State(), State(), 1);
    final Tuple<State> k2 = _calculateK(k1.a, k1.b, delta / 2);
    final Tuple<State> k3 = _calculateK(k2.a, k2.b, delta / 2);
    final Tuple<State> k4 = _calculateK(k3.a, k3.b, delta);

    final State changeA = (k1.a + k2.a * 2 + k3.a * 2 + k4.a) * delta / 6.0;
    final State changeB = (k1.b + k2.b * 2 + k3.b * 2 + k4.b) * delta / 6.0;

    a.velocityChange += changeA.acceleration;
    a.positionChange += changeA.velocity;

    b.velocityChange += changeB.acceleration;
    b.positionChange += changeB.velocity;

    // currentState.ax = this.a.position.dx;
    // currentState.ay = this.a.position.dy;
    // currentState.avx = this.a.velocity.dx;
    // currentState.avy = this.a.velocity.dy;

    // currentState.bx = this.b.position.dx;
    // currentState.by = this.b.position.dy;
    // currentState.bvx = this.b.velocity.dx;
    // currentState.bvy = this.b.velocity.dy;

    // final State a = getDerivativeAtTime(currentState, 0, State());
    // final State b = getDerivativeAtTime(currentState, delta * 0.5, a);
    // final State c = getDerivativeAtTime(currentState, delta * 0.5, b);
    // final State d = getDerivativeAtTime(currentState, delta * 0.5, c);

    // final double m1DPX = (a.ax + 2.0 * (b.ax + c.ax) + d.ax) / 6.0;
    // final double m1DPY = (a.ay + 2.0 * (b.ay + c.ay) + d.ay) / 6.0;
    // final double m2DPX = (a.bx + 2.0 * (b.bx + c.bx) + d.bx) / 6.0;
    // final double m2DPY = (a.by + 2.0 * (b.by + c.by) + d.by) / 6.0;

    // final double m1DVX = (a.avx + 2.0 * (b.avx + c.avx) + d.avx) / 6.0;
    // final double m1DVY = (a.avy + 2.0 * (b.avy + c.avy) + d.avy) / 6.0;
    // final double m2DVX = (a.bvx + 2.0 * (b.bvx + c.bvx) + d.bvx) / 6.0;
    // final double m2DVY = (a.bvy + 2.0 * (b.bvy + c.bvy) + d.bvy) / 6.0;

    // this.a.position += Offset(m1DPX * delta, m1DPY * delta);
    // this.b.position += Offset(m2DPX * delta, m2DPY * delta);

    // this.a.velocity += Offset(m1DVX * delta, m1DVY * delta);
    // this.b.velocity += Offset(m2DVX * delta, m2DVY * delta);
  }
}

class State {
  State({
    this.vx = 0,
    this.vy = 0,
    this.ax = 0,
    this.ay = 0,
  });

  // factory State.fromMassPoint(MassPoint point) {
  //   return State.fromVelocityAndAcceleration(point.velocity, point.acceleration);
  // }

  factory State.fromVelocityAndAcceleration(Offset velocity, Offset acceleration) {
    return State(
      vx: velocity.dx,
      vy: velocity.dy,
      ax: acceleration.dx,
      ay: acceleration.dy,
    );
  }

  double vx;

  double vy;

  double ax;

  double ay;

  Offset get velocity => Offset(vx, vy);

  Offset get acceleration => Offset(ax, ay);

  State operator *(double other) {
    return State.fromVelocityAndAcceleration(
      velocity * other,
      acceleration * other,
    );
  }

  State operator /(double other) {
    return State.fromVelocityAndAcceleration(
      velocity / other,
      acceleration / other,
    );
  }

  State operator +(State other) {
    return State.fromVelocityAndAcceleration(
      velocity + other.velocity,
      acceleration + other.acceleration,
    );
  }

  @override
  String toString() => '$vx $vy $ax $ay';
}
