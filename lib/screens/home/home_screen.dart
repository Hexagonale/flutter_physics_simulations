import 'package:flutter/material.dart';
import 'package:physics/screens/simulations/_simulations.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
}
