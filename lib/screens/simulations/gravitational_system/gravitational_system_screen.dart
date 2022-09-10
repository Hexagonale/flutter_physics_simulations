import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:physics/physics.dart';

import 'models/_models.dart';
import 'simulation/gravitational_simulation.dart';
import 'simulation/gravitational_simulation_setups.dart';

class GravitationalSystemScreen extends StatefulWidget {
  const GravitationalSystemScreen({Key? key}) : super(key: key);

  @override
  State<GravitationalSystemScreen> createState() => _GravitationalSystemScreenState();
}

class _GravitationalSystemScreenState extends State<GravitationalSystemScreen> with SingleTickerProviderStateMixin {
  final ValueNotifier<int> _timestamp = ValueNotifier<int>(0);

  GravitationalSimulationSetup _selectedSetup = GravitationalSimulationSetups.earthAndMoon;

  GravitationalSimulation? _simulation;

  Ticker? _ticker;

  @override
  void initState() {
    super.initState();

    _ticker = createTicker((_) {
      _timestamp.value = DateTime.now().millisecondsSinceEpoch;
    });
    _ticker!.start();
  }

  @override
  void dispose() {
    _ticker?.dispose();
    _timestamp.dispose();

    _simulation?.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: CustomPaint(
              painter: GravitationalSystemDrawer(
                simulation: _simulation,
                timestamp: _timestamp,
                gravitationalSimulationSetup: _selectedSetup,
              ),
            ),
          ),
          Positioned(
            top: 0.0,
            left: 0.0,
            right: 0.0,
            child: _buildScenarioSelector(),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioSelector() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: <Widget>[
          for (final GravitationalSimulationSetup setup in GravitationalSimulationSetups.setups)
            ElevatedButton(
              child: Text(setup.name),
              onPressed: () => _selectSetup(setup),
            ),
          const SizedBox(width: 16.0),
          Expanded(
            child: Slider(
              value: _getSliderValue(),
              min: _selectedSetup.minSpeed,
              max: _selectedSetup.maxSpeed,
              onChanged: _onSliderValueChange,
            ),
          )
        ],
      ),
    );
  }

  double _getSliderValue() {
    if (_simulation == null) {
      return _selectedSetup.initialSpeed;
    }

    final double value = sqrt(_simulation!.simulationSpeed);
    return value.clamp(
      _selectedSetup.minSpeed,
      _selectedSetup.maxSpeed,
    );
  }

  void _onSliderValueChange(double value) {
    if (_simulation == null) {
      return;
    }

    _simulation!.simulationSpeed = value * value;
    setState(() {});
  }

  void _selectSetup(GravitationalSimulationSetup setup) {
    _selectedSetup = setup;
    _simulation = GravitationalSimulation.fromSetup(setup);

    _simulation!.init();

    setState(() {});
  }
}

class GravitationalSystemDrawer extends CustomPainter {
  GravitationalSystemDrawer({
    required this.simulation,
    required this.timestamp,
    required this.gravitationalSimulationSetup,
  }) : super(repaint: timestamp);

  final GravitationalSimulation? simulation;
  final ValueNotifier<int> timestamp;
  final GravitationalSimulationSetup gravitationalSimulationSetup;

  late final double _minimalRadius = 10 / gravitationalSimulationSetup.scale;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.scale(gravitationalSimulationSetup.scale);
    size /= gravitationalSimulationSetup.scale;

    final Paint backgroundPaint = Paint()..color = const Color(0xff3f3f3f);
    canvas.drawRect(
      Rect.fromLTWH(0.0, 0.0, size.width, size.height),
      backgroundPaint,
    );

    if (simulation == null) {
      return;
    }

    canvas.translate(size.width / 2, size.height / 2);

    final Paint objectPaint = Paint()..color = const Color(0xffff5555);

    final Vector2 massCenter = simulation!.massCenter;
    canvas.translate(-massCenter.dx, -massCenter.dy);
    canvas.drawCircle(massCenter, 5.0 / gravitationalSimulationSetup.scale, Paint()..color = const Color(0xffffffff));

    for (final ObjectState<Vector2, GravitationalObject> state in simulation!.states) {
      final double radius = state.object.mass * gravitationalSimulationSetup.massScale;

      canvas.drawCircle(state.position, max(radius, _minimalRadius), objectPaint);
    }
  }

  @override
  bool shouldRepaint(covariant GravitationalSystemDrawer oldDelegate) {
    return oldDelegate.simulation != simulation || oldDelegate.timestamp.value != timestamp.value;
  }
}
