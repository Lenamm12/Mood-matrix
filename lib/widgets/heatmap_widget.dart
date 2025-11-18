import 'package:flutter/material.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
import 'package:mood_matrix/models/entry.dart';
import 'package:mood_matrix/notifier/entry_notifier.dart';
import 'package:provider/provider.dart';

import '../models/moods.dart';

// ignore: constant_identifier_names
enum HeatmapTime { WEEK, MONTH, YEAR }

class HeatmapWidget extends StatefulWidget {
  const HeatmapWidget({super.key});

  @override
  State<HeatmapWidget> createState() => _HeatmapWidgetState();
}

class _HeatmapWidgetState extends State<HeatmapWidget> {
  HeatmapTime? selectedTime = HeatmapTime.WEEK;

  @override
  Widget build(BuildContext context) {
    return Consumer<EntryNotifier>(
      builder: (context, entryNotifier, child) {
        if (entryNotifier.entries.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.noEntries));
        }

        List<Entry> entriesWithDate = entryNotifier.entries.toList();

        final now = DateTime.now();
        List<Entry> filteredEntries;

        switch (selectedTime) {
          case HeatmapTime.WEEK:
            final weekAgo = now.subtract(const Duration(days: 7));
            filteredEntries =
                entriesWithDate
                    .where(
                      (entry) => DateTime.parse(entry.date).isAfter(weekAgo),
                    )
                    .toList();
            break;
          case HeatmapTime.MONTH:
            final monthAgo = now.subtract(const Duration(days: 30));
            filteredEntries =
                entriesWithDate
                    .where(
                      (entry) => DateTime.parse(entry.date).isAfter(monthAgo),
                    )
                    .toList();
            break;
          case HeatmapTime.YEAR:
            final yearAgo = now.subtract(const Duration(days: 365));
            filteredEntries =
                entriesWithDate
                    .where(
                      (entry) => DateTime.parse(entry.date).isAfter(yearAgo),
                    )
                    .toList();
            break;
          default:
            filteredEntries = entriesWithDate;
        }

        return Column(
          children: [
            const SizedBox(height: 20),
            DropdownButton<HeatmapTime>(
              value: selectedTime,
              onChanged: (HeatmapTime? newValue) {
                setState(() {
                  selectedTime = newValue;
                });
              },
              items:
                  HeatmapTime.values.map((HeatmapTime time) {
                    return DropdownMenuItem<HeatmapTime>(
                      value: time,
                      child: Text(time.toString().split('.').last),
                    );
                  }).toList(),
            ),
            MoodBoardWidget(entries: filteredEntries),
          ],
        );
      },
    );
  }
}

class MoodBoardWidget extends StatefulWidget {
  const MoodBoardWidget({super.key, required this.entries});
  final List<Entry> entries;

  @override
  State<MoodBoardWidget> createState() => _MoodBoardWidgetState();
}

class _MoodBoardWidgetState extends State<MoodBoardWidget> {
  @override
  Widget build(BuildContext context) {
    final Map<Mood, int> moodCount = {};

    for (final entry in widget.entries) {
      try {
        final mood = Mood.values.byName(entry.mood);

        moodCount.update(mood, (value) => value + 1, ifAbsent: () => 1);
      } catch (e) {
        // Mood probably deleted
      }
    }

    final totalCount = moodCount.values.fold(0, (p, c) => p + c);

    return SizedBox(
      height: 400,
      child: GridView.count(
        crossAxisCount: 6,
        padding: const EdgeInsets.all(8.0),
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        children: List.generate(Mood.values.length, (index) {
          final qIndex = (index ~/ 6 < 3 ? 0 : 2) + (index % 6 < 3 ? 0 : 1);
          final quadrant = MoodQuadrant.values[qIndex];
          final mood = Mood.values[index];
          final label = getMoodTranslation(context, mood);

          final count = moodCount[mood] ?? 0;

          final percentage = totalCount == 0 ? 0.0 : count / totalCount;

          return MoodWidget(
            quadrant: quadrant,
            label: label,
            onTap: () {},
            percentage: percentage,
          );
        }),
      ),
    );
  }
}

class MoodWidget extends StatelessWidget {
  const MoodWidget({
    super.key,
    required this.quadrant,
    required this.label,
    required this.onTap,
    this.percentage,
  });

  final MoodQuadrant quadrant;
  final String label;
  final VoidCallback onTap;
  final double? percentage;

  @override
  Widget build(BuildContext context) {
    final opacity =
        percentage == null ? 0.1 : (percentage! * 5).clamp(0.1, 1.0);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color:
              quadrant == MoodQuadrant.highEnergyUnpleasant
                  ? Colors.red.withOpacity(opacity)
                  : quadrant == MoodQuadrant.highEnergyPleasant
                  ? Colors.yellow.withOpacity(opacity)
                  : quadrant == MoodQuadrant.lowEnergyUnpleasant
                  ? Colors.blue.withOpacity(opacity)
                  : quadrant == MoodQuadrant.lowEnergyPleasant
                  ? Colors.green.withOpacity(opacity)
                  : Colors.transparent,
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, color: Colors.black),
            ),
          ),
        ),
      ),
    );
  }
}
