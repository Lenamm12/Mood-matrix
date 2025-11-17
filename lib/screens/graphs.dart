import 'package:flutter/material.dart';
import 'package:mood_matrix/screens/heatmap_screen.dart';

class GraphsScreen extends StatelessWidget {
  const GraphsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Graphs')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const HeatmapScreen(),
                  ),
                );
              },
              child: const HeatmapScreen(),
            ),
          ],
        ),
      ),
    );
  }
}
