import 'package:flutter/material.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
import 'package:mood_matrix/screens/heatmap_screen.dart';

class GraphsScreen extends StatelessWidget {
  const GraphsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.graphs)),
      body: Center(
        child: Column( children: [ const HeatmapScreen(),
          const SizedBox(height: 10),
          Text("...")
        ],

        ),
      ),
    );
  }
}
