import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
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
  List<Entry> _filteredEntries = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _entries = DatabaseHelper.instance.getEntries();
    _entries.then((entries) {
      setState(() {
        _filteredEntries = entries;
      });
    });
    _searchController.addListener(_filterEntries);
  }

  void _filterEntries() {
    final query = _searchController.text.toLowerCase();
    _entries.then((entries) {
      setState(() {
        _filteredEntries = entries.where((entry) {
          final mood = entry.mood.toLowerCase();
          final notes = entry.notes?.toLowerCase() ?? '';
          final date = DateFormat.yMd()
              .add_jm()
              .format(DateTime.parse(entry.date).toLocal())
              .toLowerCase();
          return mood.contains(query) ||
              notes.contains(query) ||
              date.contains(query);
        }).toList();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String getMoodTranslation(BuildContext context, Mood mood) {
    switch (mood) {
      case Mood.Enraged:
        return AppLocalizations.of(context)!.enraged;
      case Mood.Stressed:
        return AppLocalizations.of(context)!.stressed;
      case Mood.Shocked:
        return AppLocalizations.of(context)!.shocked;
      case Mood.Surprised:
        return AppLocalizations.of(context)!.surprised;
      case Mood.Festive:
        return AppLocalizations.of(context)!.festive;
      case Mood.Ecstatic:
        return AppLocalizations.of(context)!.ecstatic;
      case Mood.Fuming:
        return AppLocalizations.of(context)!.fuming;
      case Mood.Angry:
        return AppLocalizations.of(context)!.angry;
      case Mood.Restless:
        return AppLocalizations.of(context)!.restless;
      case Mood.Energized:
        return AppLocalizations.of(context)!.energized;
      case Mood.Optimistic:
        return AppLocalizations.of(context)!.optimistic;
      case Mood.Excited:
        return AppLocalizations.of(context)!.excited;
      case Mood.Repulsed:
        return AppLocalizations.of(context)!.repulsed;
      case Mood.Worried:
        return AppLocalizations.of(context)!.worried;
      case Mood.Uneasy:
        return AppLocalizations.of(context)!.uneasy;
      case Mood.Pleasant:
        return AppLocalizations.of(context)!.pleasant;
      case Mood.Hopeful:
        return AppLocalizations.of(context)!.hopeful;
      case Mood.Blissful:
        return AppLocalizations.of(context)!.blissful;
      case Mood.Disgusted:
        return AppLocalizations.of(context)!.disgusted;
      case Mood.Down:
        return AppLocalizations.of(context)!.down;
      case Mood.Apathetic:
        return AppLocalizations.of(context)!.apathetic;
      case Mood.Ease:
        return AppLocalizations.of(context)!.ease;
      case Mood.Content:
        return AppLocalizations.of(context)!.content;
      case Mood.Fulfilled:
        return AppLocalizations.of(context)!.fulfilled;
      case Mood.Miserable:
        return AppLocalizations.of(context)!.miserable;
      case Mood.Lonely:
        return AppLocalizations.of(context)!.lonely;
      case Mood.Tired:
        return AppLocalizations.of(context)!.tired;
      case Mood.Relaxed:
        return AppLocalizations.of(context)!.relaxed;
      case Mood.Restful:
        return AppLocalizations.of(context)!.restful;
      case Mood.Balanced:
        return AppLocalizations.of(context)!.balanced;
      case Mood.Despair:
        return AppLocalizations.of(context)!.despair;
      case Mood.Desolate:
        return AppLocalizations.of(context)!.desolate;
      case Mood.Drained:
        return AppLocalizations.of(context)!.drained;
      case Mood.Sleepy:
        return AppLocalizations.of(context)!.sleepy;
      case Mood.Tranquil:
        return AppLocalizations.of(context)!.tranquil;
      case Mood.Serene:
        return AppLocalizations.of(context)!.serene;
    }
  }

  Color getMoodColor(String mood, BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
    final moodIndex =
        Mood.values.indexWhere((m) => m.toString().split('.').last == mood);
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
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.history),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration:  InputDecoration(
                labelText: AppLocalizations.of(context)!.search,
                hintText: AppLocalizations.of(context)!.searchHint,
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                ),
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Entry>>(
              future: _entries,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(
                      child: Text(AppLocalizations.of(context)!.noEntries));
                } else {
                  return ListView.builder(
                    itemCount: _filteredEntries.length,
                    itemBuilder: (context, index) {
                      final entry = _filteredEntries[index];
                      final dateTime = DateTime.parse(entry.date).toLocal();
                      final formattedDate =
                          DateFormat.yMd(AppLocalizations.of(context)!.localeName).add_Hm().format(dateTime);
                      final mood = Mood.values.firstWhere(
                          (m) => m.toString().split('.').last == entry.mood);
                      return ListTile(
                        leading: Icon(
                          Icons.circle,
                          color: getMoodColor(entry.mood, context),
                        ),
                        title: Text(getMoodTranslation(context, mood)),
                        subtitle: Text(entry.notes ?? ''),
                        trailing: Text(formattedDate),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
