import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/Moods.dart';
import '../models/entry.dart';
import '../notifier/entry_notifier.dart';
import '../notifier/theme_notifier.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  User? get currentUser => _auth.currentUser;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    if (currentUser != null) {
      Provider.of<EntryNotifier>(
        context,
        listen: false,
      ).syncFromFirestore(currentUser!);
    }
  }

  List<Entry> _getEntriesForDay(DateTime day, List<Entry> entries) {
    final normalizedDay = DateTime(day.year, day.month, day.day);
    return entries
        .where(
          (entry) =>
              isSameDay(DateTime.parse(entry.date).toLocal(), normalizedDay),
        )
        .toList();
  }

  Color getMoodColor(String mood, BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final moodIndex = Mood.values.indexWhere(
      (m) => m.toString().split('.').last == mood,
    );
    if (moodIndex == -1) {
      return Colors.grey; // Default color if mood not found
    }

    final qIndex = (moodIndex ~/ 6 < 3 ? 0 : 2) + (moodIndex % 6 < 3 ? 0 : 1);
    final quadrant = MoodQuadrant.values[qIndex];

    if (themeNotifier.isDarkMode) {
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
    } else {
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
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.calendar)),
      body: Consumer<EntryNotifier>(
        builder: (context, entryNotifier, child) {
          final entries = entryNotifier.entries;
          final selectedEntries = _getEntriesForDay(_selectedDay!, entries);

          return Column(
            children: [
              TableCalendar(
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                locale: AppLocalizations.of(context)!.localeName,
                focusedDay: _focusedDay,
                calendarFormat: _calendarFormat,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                onDaySelected: (selectedDay, focusedDay) {
                  if (!isSameDay(_selectedDay, selectedDay)) {
                    setState(() {
                      _selectedDay = selectedDay;
                      _focusedDay = focusedDay;
                    });
                  }
                },
                onFormatChanged: (format) {
                  if (_calendarFormat != format) {
                    setState(() {
                      _calendarFormat = format;
                    });
                  }
                },
                onPageChanged: (focusedDay) {
                  _focusedDay = focusedDay;
                },
                eventLoader: (day) {
                  return _getEntriesForDay(day, entries);
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    if (events.isNotEmpty) {
                      return Positioned(
                        left: 1,
                        bottom: 1,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children:
                              events.reversed.map((event) {
                                final entry = event as Entry;
                                return Container(
                                  width: 7.0,
                                  height: 7.0,
                                  margin: const EdgeInsets.symmetric(
                                    horizontal: 1.5,
                                  ),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: getMoodColor(entry.mood, context),
                                  ),
                                );
                              }).toList(),
                        ),
                      );
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(height: 8.0),
              Expanded(child: _buildEntriesList(selectedEntries)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildEntriesList(List<Entry> selectedEntries) {
    if (selectedEntries.isEmpty) {
      return Center(child: Text(AppLocalizations.of(context)!.noEntries));
    }

    return ListView.builder(
      itemCount: selectedEntries.length,
      itemBuilder: (context, index) {
        final entry = selectedEntries[index];
        final dateTime = DateTime.parse(entry.date).toLocal();
        final formattedDate = DateFormat.Hm(
          AppLocalizations.of(context)!.localeName,
        ).format(dateTime);

        return ListTile(
          title: Text(entry.mood),
          subtitle: Text(entry.notes ?? ""),
          trailing: Text(formattedDate),
        );
      },
    );
  }
}
