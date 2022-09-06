import 'package:flutter/material.dart';
import 'package:physics/screens/simulations/_simulations.dart';

import '../simulations/temp/temp.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff333333),
      body: Center(
        child: Column(
          children: [
            const SizedBox(height: 64.0),
            ElevatedButton(
              child: const Text('Worm'),
              onPressed: () => _routeToWorm(context),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Softbody'),
              onPressed: () => _routeToSoftbody(context),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('TempScreen'),
              onPressed: () => _routeToTempScreen(context),
            ),
          ],
        ),
      ),
    );
  }

  void _routeToWorm(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const WormScreen()),
    );
  }

  void _routeToSoftbody(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const SoftbodyScreen()),
    );
  }

  void _routeToTempScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const TempScreen()),
    );
  }
}
