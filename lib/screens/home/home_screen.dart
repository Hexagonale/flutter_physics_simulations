import 'package:flutter/material.dart';
import 'package:physics/screens/simulations/_simulations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xff333333),
      body: Center(
        child: Column(
          children: <Widget>[
            const SizedBox(height: 64.0),
            ElevatedButton(
              child: const Text('Worm'),
              onPressed: () => _routeToWorm(context),
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              child: const Text('Gravitational system'),
              onPressed: () => _routeToGravitation(context),
            ),
          ],
        ),
      ),
    );
  }

  void _routeToWorm(BuildContext context) {
    Navigator.push<void>(
      context,
      MaterialPageRoute<void>(builder: (_) => const WormScreen()),
    );
  }

  void _routeToGravitation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const GravitationalSystemScreen()),
    );
  }
}
