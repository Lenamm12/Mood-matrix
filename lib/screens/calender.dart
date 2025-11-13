import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import '../models/entry.dart';
import '../database/database_helper.dart'; // Import DatabaseHelper

int getDaysInMonth(int year, int month) {
  if (month == DateTime.february) {
    return isLeapYear(year) ? 29 : 28;
  } else if (month == DateTime.april ||
      month == DateTime.june ||
      month == DateTime.september ||
      month == DateTime.november) {
    return 30;
  } else {
    return 31;
  }
}

// Helper function to check for leap year
bool isLeapYear(int year) {
  return (year % 4 == 0 && year % 100 != 0) || (year % 400 == 0);
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  CalendarFormat _calendarFormat = CalendarFormat.month;
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<Entry>> _entries = {};
  List<Entry> _selectedEntries = [];

  User? get currentUser => _auth.currentUser;

  @override
  void initState() {
    super.initState();
    _selectedDay = _focusedDay;
    _loadEntries();
  }

  void _loadEntries() {
    if (currentUser == null) return;

    _firestore
        .collection('users')
        .doc(currentUser!.uid)
        .collection('entries')
        .snapshots()
        .listen((snapshot) {
          final Map<DateTime, List<Entry>> entries = {};
          for (var doc in snapshot.docs) {
            final entry = Entry.fromFirestore(doc);
            final date = DateTime.parse(entry.date).toLocal();
            final day = DateTime(date.year, date.month, date.day);
            if (entries[day] == null) {
              entries[day] = [];
            }
            entries[day]!.add(entry);
          }
          setState(() {
            _entries = entries;
            _selectedEntries = _getEntriesForDay(_selectedDay!);
          });
        });
  }

  List<Entry> _getEntriesForDay(DateTime day) {
    return _entries[DateTime(day.year, day.month, day.day)] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calendar')),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            calendarFormat: _calendarFormat,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              if (!isSameDay(_selectedDay, selectedDay)) {
                setState(() {
                  _selectedDay = selectedDay;
                  _focusedDay = focusedDay;
                  _selectedEntries = _getEntriesForDay(selectedDay);
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
              return _getEntriesForDay(day);
            },
          ),
          const SizedBox(height: 8.0),
          Expanded(child: _buildEntriesList()),
        ],
      ),
    );
  }

  Widget _buildEntriesList() {
    if (_selectedEntries.isEmpty) {
      return const Center(child: Text('No entries for this day.'));
    }

    return ListView.builder(
      itemCount: _selectedEntries.length,
      itemBuilder: (context, index) {
        final entry = _selectedEntries[index];
        return ListTile(
          title: Text(entry.mood),
          subtitle: Text(entry.notes ?? ""),
        );
      },
    );
  }
}
