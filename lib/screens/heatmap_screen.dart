import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';
import 'package:mood_matrix/database/database_helper.dart';
import 'package:mood_matrix/models/entry.dart';

class HeatmapScreen extends StatefulWidget {
  const HeatmapScreen({super.key});

  @override
  State<HeatmapScreen> createState() => _HeatmapScreenState();
}

class _HeatmapScreenState extends State<HeatmapScreen> {
  late Future<List<Entry>> _entries;
  HeatmapViewType _viewType = HeatmapViewType.monthly;

  @override
  void initState() {
    super.initState();
    _entries = DatabaseHelper.instance.getEntries();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Heatmap'),
        actions: [
          PopupMenuButton<HeatmapViewType>(
            onSelected: (type) {
              setState(() {
                _viewType = type;
              });
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: HeatmapViewType.weekly,
                child: Text('Weekly'),
              ),
              const PopupMenuItem(
                value: HeatmapViewType.monthly,
                child: Text('Monthly'),
              ),
              const PopupMenuItem(
                value: HeatmapViewType.yearly,
                child: Text('Yearly'),
              ),
            ],
          ),
        ],
      ),
      body: FutureBuilder<List<Entry>>(
        future: _entries,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No entries found.'));
          } else {
            final entries = snapshot.data!;
            final heatmapData = {
              for (var entry in entries) DateTime.parse(entry.date): 1,
            };

            return HeatMap(
              datasets: heatmapData,
              colorsets: const {
                1: Colors.red,
                3: Colors.orange,
                5: Colors.yellow,
                7: Colors.green,
                9: Colors.blue,
                11: Colors.indigo,
                13: Colors.purple,
              },
              onClick: (value) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(value.toString())));
              },
            );
          }
        },
      ),
    );
  }
}

enum HeatmapViewType {
  weekly,
  monthly,
  yearly,
}
