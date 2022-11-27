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
      gravitationalConstant: PhysicsConstants.gravitationalConstantEPlus15,
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
      maxSpeed: 1000.0 * 1000.0 * 5.0,
      initialSpeed: 1000.0 * 500.0,
    );

    return setup;
  }

  static GravitationalSimulationSetup get twoObjectsOrbitingEachOther {
    const double m1 = 1000 * 1000 * 1000 * 1000 * 150;
    const double m2 = 1000 * 1000 * 1000 * 1000 * 100;

    const Vector2 p1 = Vector2(0.0, 10.0);
    const Vector2 p2 = Vector2(10.0, -30.0);

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
      name: 'Two objects orbiting each other',
      gravitationalSystem: system,
      states: states,
      scale: 10,
      massScale: 1 / 1000 / 1000 / 1000 / 1000 / 50,
      minSpeed: 1.0,
      maxSpeed: 10.0,
      initialSpeed: 1.0,
    );

    return setup;
  }

  static GravitationalSimulationSetup get heckALotOfObjects {
    const double m1 = 1000 * 1000 * 1000 * 10000 * 50;
    const double m2 = 1000 * 1000 * 1000 * 10000 * 100;
    const double m3 = 1000 * 1000 * 1000 * 10000 * 150;
    const double m4 = 1000 * 1000 * 1000 * 10000 * 100;
    const double m5 = 1000 * 1000 * 1000 * 10000 * 50;
    const double m6 = 1000 * 1000 * 1000 * 10000 * 100;
    const double m7 = 1000 * 1000 * 1000 * 10000 * 50;
    const double m8 = 1000 * 1000 * 1000 * 10000 * 100;

    const Vector2 p1 = Vector2(0.0, 100.0);
    const Vector2 p2 = Vector2(100.0, -300.0);
    const Vector2 p3 = Vector2(100.0, 300.0);
    const Vector2 p4 = Vector2(-100.0, -300.0);
    const Vector2 p5 = Vector2(-100.0, 300.0);
    const Vector2 p6 = Vector2(300.0, -300.0);
    const Vector2 p7 = Vector2(600.0, -600.0);
    const Vector2 p8 = Vector2(200.0, -800.0);

    const GravitationalObject object1 = GravitationalObject(
      mass: m1,
    );

    const GravitationalObject object2 = GravitationalObject(
      mass: m2,
    );

    const GravitationalObject object3 = GravitationalObject(
      mass: m3,
    );

    const GravitationalObject object4 = GravitationalObject(
      mass: m4,
    );

    const GravitationalObject object5 = GravitationalObject(
      mass: m5,
    );

    const GravitationalObject object6 = GravitationalObject(
      mass: m6,
    );

    const GravitationalObject object7 = GravitationalObject(
      mass: m7,
    );

    const GravitationalObject object8 = GravitationalObject(
      mass: m8,
    );

    const GravitationalSystem system = GravitationalSystem(
      objects: <GravitationalObject>[
        object1,
        object2,
        object3,
        object4,
        object5,
        object6,
        object7,
        object8,
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
      ObjectState<Vector2, GravitationalObject>(
        position: p3,
        velocity: Vector2(-v1, 0.0),
        object: object2,
      ),
      ObjectState<Vector2, GravitationalObject>(
        position: p4,
        velocity: Vector2(-v2, 0.0),
        object: object2,
      ),
      ObjectState<Vector2, GravitationalObject>(
        position: p5,
        velocity: Vector2(v2, 0.0),
        object: object2,
      ),
      ObjectState<Vector2, GravitationalObject>(
        position: p6,
        velocity: Vector2(-v1, 0.0),
        object: object2,
      ),
      ObjectState<Vector2, GravitationalObject>(
        position: p7,
        velocity: Vector2(v1, 0.0),
        object: object2,
      ),
      ObjectState<Vector2, GravitationalObject>(
        position: p8,
        velocity: Vector2(v2, 0.0),
        object: object2,
      ),
    ];

    final GravitationalSimulationSetup setup = GravitationalSimulationSetup(
      name: 'Lot',
      gravitationalSystem: system,
      states: states,
      scale: 0.005,
      massScale: 1 / 1000 / 1000 / 1000 / 1000 / 50,
      minSpeed: 1.0,
      maxSpeed: 100.0 * 100.0,
      initialSpeed: 1.0,
    );

    return setup;
  }

  static List<GravitationalSimulationSetup> get setups => <GravitationalSimulationSetup>[
        earthAndMoon,
        twoObjectsOrbitingEachOther,
        heckALotOfObjects,
      ];
}
