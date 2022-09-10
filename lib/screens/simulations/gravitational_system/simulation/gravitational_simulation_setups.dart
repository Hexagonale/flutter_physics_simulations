import 'dart:math';

import 'package:physics/physics.dart';

import '../models/_models.dart';

abstract class GravitationalSimulationSetups {
  static GravitationalSimulationSetup get earthAndMoon {
    const double earthMass = PhysicsConstants.earthMassEMinus15;
    const double moonMass = PhysicsConstants.moonMassEMinus15;

    const Vector2 earthPosition = Vector2(0.0, 0.0);
    const Vector2 moonPosition = Vector2(0.0, -385000000);

    const GravitationalObject earth = GravitationalObject(
      mass: earthMass,
    );

    const GravitationalObject moon = GravitationalObject(
      mass: moonMass,
    );

    const GravitationalSystem system = GravitationalSystem(
      objects: <GravitationalObject>[
        earth,
        moon,
      ],
    );

    final double distance = (earthPosition - moonPosition).distance;
    final double v2 = sqrt((system.gravitationalConstant * earthMass) / distance);

    final List<ObjectState<Vector2, GravitationalObject>> states = <ObjectState<Vector2, GravitationalObject>>[
      const ObjectState<Vector2, GravitationalObject>(
        position: earthPosition,
        velocity: Vector2.zero,
        object: earth,
      ),
      ObjectState<Vector2, GravitationalObject>(
        position: moonPosition,
        velocity: Vector2(-v2, 0.0),
        object: moon,
      ),
    ];

    final GravitationalSimulationSetup setup = GravitationalSimulationSetup(
      name: 'Earth and moon',
      gravitationalSystem: system,
      states: states,
      scale: 0.0000005,
      massScale: 0.005,
      minSpeed: 1.0,
      maxSpeed: 1000.0,
      initialSpeed: 10.0,
    );

    return setup;
  }

  static GravitationalSimulationSetup get twoObjectsOrbitingEachOther {
    const double m1 = 100;
    const double m2 = 50;

    const Vector2 p1 = Vector2(0.0, 100.0);
    const Vector2 p2 = Vector2(100.0, -300.0);

    const GravitationalObject object1 = GravitationalObject(
      mass: m1,
    );

    const GravitationalObject object2 = GravitationalObject(
      mass: m2,
    );

    const GravitationalSystem system = GravitationalSystem(
      objects: <GravitationalObject>[
        object1,
        object2,
      ],
    );

    final double distance = (p1 - p2).distance;
    final double denominator = distance * (m1 + m2);

    final double v1 = sqrt(system.gravitationalConstant * m2 * m2 / denominator);
    final double v2 = sqrt(system.gravitationalConstant * m1 * m1 / denominator);

    final List<ObjectState<Vector2, GravitationalObject>> states = <ObjectState<Vector2, GravitationalObject>>[
      ObjectState<Vector2, GravitationalObject>(
        position: p1,
        velocity: Vector2(v1, 0.0),
        object: object1,
      ),
      ObjectState<Vector2, GravitationalObject>(
        position: p2,
        velocity: Vector2(-v2, 0.0),
        object: object2,
      ),
    ];

    final GravitationalSimulationSetup setup = GravitationalSimulationSetup(
      name: 'Earth and moon',
      gravitationalSystem: system,
      states: states,
      scale: 0.0000005,
      massScale: 0.005,
      minSpeed: 1.0,
      maxSpeed: 1000.0,
      initialSpeed: 10.0,
    );

    return setup;
  }

  static final List<GravitationalSimulationSetup> setups = <GravitationalSimulationSetup>[
    earthAndMoon,
    twoObjectsOrbitingEachOther,
  ];
}
