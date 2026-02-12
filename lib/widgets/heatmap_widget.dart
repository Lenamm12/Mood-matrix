import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
import 'package:mood_matrix/models/entry.dart';
import 'package:mood_matrix/notifier/entry_notifier.dart';
import 'package:provider/provider.dart';

import '../models/moods.dart';
import '../notifier/theme_notifier.dart';

// ignore: constant_identifier_names
enum HeatmapTime { WEEK, MONTH, YEAR }

class HeatmapWidget extends StatefulWidget {
  const HeatmapWidget({super.key});

  @override
  State<HeatmapWidget> createState() => _HeatmapWidgetState();
}

class _HeatmapWidgetState extends State<HeatmapWidget> {
  HeatmapTime _timeframe = HeatmapTime.WEEK;
  late DateTime _endDate;

  @override
  void initState() {
    super.initState();
    _endDate = DateTime.now();
  }

  DateTime _addMonths(DateTime date, int months) {
    var newMonth = date.month + months;
    var newYear = date.year;

    while (newMonth > 12) {
      newMonth -= 12;
      newYear++;
    }
    while (newMonth <= 0) {
      newMonth += 12;
      newYear--;
    }

    final daysInNewMonth = DateUtils.getDaysInMonth(newYear, newMonth);
    final newDay = date.day > daysInNewMonth ? daysInNewMonth : date.day;

    return DateTime(
      newYear,
      newMonth,
      newDay,
      date.hour,
      date.minute,
      date.second,
      date.millisecond,
      date.microsecond,
    );
  }

  void _navigateDate(bool forward) {
    setState(() {
      DateTime newEndDate;
      switch (_timeframe) {
        case HeatmapTime.WEEK:
          newEndDate = _endDate.add(Duration(days: forward ? 7 : -7));
          break;
        case HeatmapTime.MONTH:
          newEndDate = _addMonths(_endDate, forward ? 1 : -1);
          break;
        case HeatmapTime.YEAR:
          newEndDate = DateTime(
            _endDate.year + (forward ? 1 : -1),
            _endDate.month,
            _endDate.day,
          );
          break;
      }

      if (newEndDate.isAfter(DateTime.now())) {
        _endDate = DateTime.now();
      } else {
        _endDate = newEndDate;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<EntryNotifier>(
      builder: (context, entryNotifier, child) {
        if (entryNotifier.entries.isEmpty) {
          return Center(child: Text(AppLocalizations.of(context)!.noEntries));
        }

        List<Entry> entriesWithDate = entryNotifier.entries.toList();

        final DateTime startDate;
        switch (_timeframe) {
          case HeatmapTime.WEEK:
            startDate = _endDate.subtract(const Duration(days: 7));
            break;
          case HeatmapTime.MONTH:
            startDate = _addMonths(_endDate, -1);
            break;
          case HeatmapTime.YEAR:
            startDate = DateTime(
              _endDate.year - 1,
              _endDate.month,
              _endDate.day,
            );
            break;
        }

        final filteredEntries =
            entriesWithDate.where((entry) {
              final entryDate = DateTime.parse(entry.date);
              return entryDate.isAfter(startDate) &&
                  entryDate.isBefore(_endDate);
            }).toList();

        final bool canNavigateForward =
            !DateUtils.isSameDay(_endDate, DateTime.now());

        return Column(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed:
                      () => setState(() {
                        _timeframe = HeatmapTime.WEEK;
                        _endDate = DateTime.now();
                      }),
                  child: const Text('Week'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed:
                      () => setState(() {
                        _timeframe = HeatmapTime.MONTH;
                        _endDate = DateTime.now();
                      }),
                  child: const Text('Month'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed:
                      () => setState(() {
                        _timeframe = HeatmapTime.YEAR;
                        _endDate = DateTime.now();
                      }),
                  child: const Text('Year'),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => _navigateDate(false),
                ),
                Text(
                  _timeframe == HeatmapTime.YEAR
                      ? DateFormat.y().format(_endDate)
                      : '${DateFormat.yMd().format(startDate)} - ${DateFormat.yMd().format(_endDate)}',
                ),
                IconButton(
                  icon: const Icon(Icons.arrow_forward),
                  onPressed:
                      canNavigateForward ? () => _navigateDate(true) : null,
                ),
              ],
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
  void _showMoodEntries(BuildContext context, Mood mood) {
    final moodEntries =
        widget.entries.where((entry) {
          try {
            return Mood.values.byName(entry.mood) == mood;
          } catch (e) {
            return false;
          }
        }).toList();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Entries for ${getMoodTranslation(context, mood)}'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: moodEntries.length,
              itemBuilder: (context, index) {
                final entry = moodEntries[index];
                return ListTile(
                  title: Text(
                    DateFormat.yMMMd().format(DateTime.parse(entry.date)),
                  ),
                  subtitle: Text(entry.notes ?? ""),
                );
              },
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

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
            onTap: () => _showMoodEntries(context, mood),
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
    final themeNotifier = Provider.of<ThemeNotifier>(context);

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
              style: TextStyle(
                fontSize: 12,
                color: themeNotifier.isDarkMode ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
