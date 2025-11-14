import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../models/entry.dart';
import '../models/theme_notifier.dart';
import 'add_mood.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  late Future<List<Entry>> _entries;

  @override
  void initState() {
    super.initState();
    _entries = DatabaseHelper.instance.getEntries();
  }

  Color getMoodColor(String mood, BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final moodIndex = Mood.values.indexWhere((m) => m.toString().split('.').last == mood);
    if (moodIndex == -1) {
      return Colors.grey; // Default color if mood not found
    }

    final qIndex = (moodIndex ~/ 6 < 3 ? 0 : 2) + (moodIndex % 6 < 3 ? 0 : 1);
    final quadrant = MoodQuadrant.values[qIndex];

    if(themeNotifier.isDarkMode) {
      switch (quadrant) {
        case MoodQuadrant.highEnergyUnpleasant:
          return Colors.red.shade400;
        case MoodQuadrant.highEnergyPleasant:
          return Colors.yellow.shade400;
        case MoodQuadrant.lowEnergyUnpleasant:
          return Colors.blue.shade400;
        case MoodQuadrant.lowEnergyPleasant:
          return Colors.green.shade400;
      }
    }
    else{
      switch (quadrant) {
        case MoodQuadrant.highEnergyUnpleasant:
          return Colors.red.shade200;
        case MoodQuadrant.highEnergyPleasant:
          return Colors.yellow.shade200;
        case MoodQuadrant.lowEnergyUnpleasant:
          return Colors.blue.shade200;
        case MoodQuadrant.lowEnergyPleasant:
          return Colors.green.shade200;
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
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
            return ListView.builder(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                final entry = entries[index];
                final dateTime = DateTime.parse(entry.date).toLocal();
                final formattedDate = DateFormat.yMd().add_jm().format(dateTime);
                return ListTile(
                  leading: Icon(Icons.circle, color: getMoodColor(entry.mood, context),),
                  title: Text(entry.mood),
                  subtitle: Text(entry.notes ?? ''),
                  trailing:  Text(formattedDate),
                );
              },
            );
          }
        },
      ),
    );
  }
}
