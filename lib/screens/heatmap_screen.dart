import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:mood_matrix/database/database_helper.dart';
import 'package:mood_matrix/models/Moods.dart';
import 'package:mood_matrix/models/entry.dart';

import '../l10n/app_localizations.dart';

class HeatmapWidget extends StatefulWidget {
  const HeatmapWidget({super.key});

  @override
  State<HeatmapWidget> createState() => _HeatmapWidgetState();
}

class _HeatmapWidgetState extends State<HeatmapWidget> {
  late Future<List<Entry>> _entries;

  @override
  void initState() {
    super.initState();
    _entries = DatabaseHelper.instance.getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Entry>>(
      future: _entries,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.noEntries));
        }

        final entries = snapshot.data!;
        final heatmapData = <DateTime, int>{};
        for (var entry in entries) {
          heatmapData[entry.id.isEmpty
                  ? DateTime.now()
                  : DateTime.parse(entry.date)] =
              getMoodIndex(entry.mood) + 1;
        }

        return HeatMap(
          datasets: heatmapData,
          colorsets: const {
            1: Colors.red,
            2: Colors.yellow,
            3: Colors.blue,
            4: Colors.green,
          },
          onClick: (value) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(value.toString())));
          },
        );
      },
    );
  }
}
