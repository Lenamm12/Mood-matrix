import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../database/database_helper.dart';
import '../models/Moods.dart';
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
