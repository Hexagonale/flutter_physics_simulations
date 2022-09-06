import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:physics/physics.dart';

import 'models/new/_new.dart';
import 'physics_isolate.dart';

class SoftbodySimulation {
  SoftbodySimulation({
    required this.tickerProvider,
  });

  final TickerProvider tickerProvider;

  List<Softbody> _softbodies = <Softbody>[];

  PhysicsIsolate? _physicsIsolate;

  final ValueNotifier<List<Offset>> _valueNotifier = ValueNotifier<List<Offset>>(
    [],
  );

  late final Ticker _ticker = Ticker(
    (_) => _updateNotifier(),
  );

  final int width = 8;

  void init() async {
    _softbodies.add(_createSoftbody());
    // final List<MassPoint> masses = <MassPoint>[
    //   MassPoint(0.01, const Offset(0.1, 0.5)),
    //   MassPoint(0.01, const Offset(0.1, 0.6)),
    // ];

    // _softbodies.add(Softbody(
    //   masses: masses,
    //   springs: [
    //     Spring(
    //       a: masses[0],
    //       b: masses[1],
    //     ),
    //   ],
    // ));

    await Future.delayed(Duration(milliseconds: 400), () {});

    // masses[0].position += const Offset(0, -0.1);

    _physicsIsolate = PhysicsIsolate(
      initialSoftbodies: _softbodies,
    );

    _updateNotifier();
    _ticker.start();

    _physicsIsolate?.init();
  }

  void dispose() {
    _physicsIsolate?.dispose();

    _ticker.stop();
    _ticker.dispose();

    _valueNotifier.dispose();
  }

  void applyForce() {
    _physicsIsolate?.applyForce(-10);
  }

  // void reset() {
  //   _ticker.stop();
  //   _timer?.cancel();
  //   _particles.clear();
  //   _connections.clear();

  //   init();
  // }

  // void test() async {
  //   for (int i = 0; i < 16; i++) {
  //     for (int yi = (width * 0.6).round(); yi < width; yi++) {
  //       for (int xi = (width * 0.6).round(); xi < width; xi++) {
  //         final int index = yi * width + xi;
  //         _particles[index].addForce(const Offset(0.0, -10.0));
  //       }
  //     }

  //     await Future.delayed(const Duration(milliseconds: 10));
  //   }
  // }

  Softbody _createSoftbody() {
    const double totalMass = 0.5;
    final int particlesCount = width * width;
    final double particleMass = totalMass / particlesCount;

    final List<MassPoint> particles = <MassPoint>[];
    for (int yi = 0; yi < width; yi++) {
      for (int xi = 0; xi < width; xi++) {
        final double x = xi * 0.02 + 0.5;
        final double y = yi * 0.02 + 0.3;

        final MassPoint particle = MassPoint(
          particleMass,
          Vector2(x, y),
        );

        particles.add(particle);
      }
    }

    final List<Spring> connections = <Spring>[];
    for (int yi = 0; yi < width; yi++) {
      for (int xi = 0; xi < width; xi++) {
        final int index = yi * width + xi;
        final int rightIndex = yi * width + xi + 1;
        final int downIndex = yi * width + xi + width;

        if (xi != width - 1) {
          final Spring connection = Spring(
            a: particles[index],
            b: particles[rightIndex],
          );

          connections.add(connection);
        }

        if (yi != width - 1) {
          final Spring connection = Spring(
            a: particles[index],
            b: particles[downIndex],
          );

          connections.add(connection);
        }

        if (yi != width - 1) {
          if (xi != width - 1) {
            final Spring connection = Spring(
              a: particles[index],
              b: particles[downIndex + 1],
            );

            connections.add(connection);
          }

          if (xi != 0) {
            final Spring connection = Spring(
              a: particles[index],
              b: particles[downIndex - 1],
            );

            connections.add(connection);
          }
        }
      }
    }

    return Softbody(
      masses: particles,
      springs: connections,
    );
  }

  // Softbody _createSoftbody() {
  //   final List<SoftbodyParticle> particles = <SoftbodyParticle>[];
  //   for (int yi = 0; yi < width; yi++) {
  //     for (int xi = 0; xi < width; xi++) {
  //       final double x = xi * 0.02 + 0.5;
  //       final double y = yi * 0.02 + 0.3;

  //       final SoftbodyParticle particle = SoftbodyParticle(
  //         position: Offset(x, y),
  //       );

  //       particles.add(particle);
  //     }
  //   }

  //   final List<SoftbodyConnection> connections = <SoftbodyConnection>[];
  //   for (int yi = 0; yi < width; yi++) {
  //     for (int xi = 0; xi < width; xi++) {
  //       final int index = yi * width + xi;
  //       final int rightIndex = yi * width + xi + 1;
  //       final int downIndex = yi * width + xi + width;

  //       if (xi != width - 1) {
  //         final SoftbodyConnection connection = SoftbodyConnection(
  //           a: particles[index],
  //           b: particles[rightIndex],
  //         );

  //         connections.add(connection);
  //       }

  //       if (yi != width - 1) {
  //         final SoftbodyConnection connection = SoftbodyConnection(
  //           a: particles[index],
  //           b: particles[downIndex],
  //         );

  //         connections.add(connection);
  //       }

  //       if (yi != width - 1) {
  //         if (xi != width - 1) {
  //           final SoftbodyConnection connection = SoftbodyConnection(
  //             a: particles[index],
  //             b: particles[downIndex + 1],
  //           );

  //           connections.add(connection);
  //         }

  //         if (xi != 0) {
  //           final SoftbodyConnection connection = SoftbodyConnection(
  //             a: particles[index],
  //             b: particles[downIndex - 1],
  //           );

  //           connections.add(connection);
  //         }
  //       }
  //     }
  //   }

  //   return Softbody(
  //     particles: particles,
  //     connections: connections,
  //   );
  // }

  // Future<void> _updateNotifier() async {
  //   final List<Softbody>? softbodies = await _physicsIsolate?.getSoftbodies();
  //   if (softbodies == null) {
  //     return;
  //   }

  //   _softbodies = softbodies;

  //   final Iterable<Offset> positions = _softbodies.first.particles.map(
  //     (SoftbodyParticle particle) => particle.position,
  //   );

  //   _valueNotifier.value = positions.toList();
  // }

  // ValueNotifier get notifier {
  //   return _valueNotifier;
  // }

  // List<Tuple<Offset>> get connections {
  //   final Iterable<Tuple<Offset>> offsets = _softbodies.first.connections.map(
  //     (SoftbodyConnection connection) => Tuple(connection.a.position, connection.b.position),
  //   );

  //   return offsets.toList();
  // }

  Future<void> _updateNotifier() async {
    final List<Softbody>? softbodies = await _physicsIsolate?.getSoftbodies();
    if (softbodies == null) {
      return;
    }

    _softbodies = softbodies;

    final Iterable<Offset> positions = _softbodies.first.masses.map(
      (MassPoint particle) => particle.position,
    );

    _valueNotifier.value = positions.toList();
  }

  ValueNotifier get notifier {
    return _valueNotifier;
  }

  List<Tuple<Offset>> get connections {
    final Iterable<Tuple<Offset>> offsets = _softbodies.first.springs.map(
      (Spring connection) => Tuple(connection.a.position, connection.b.position),
    );

    return offsets.toList();
  }
}
