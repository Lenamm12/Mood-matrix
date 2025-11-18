import 'package:flutter/material.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
import 'package:mood_matrix/models/entry.dart';
import 'package:mood_matrix/notifier/entry_notifier.dart';
import 'package:provider/provider.dart';

import '../models/Moods.dart';

class AddMood extends StatefulWidget {
  const AddMood({super.key});

  @override
  State<AddMood> createState() => _AddMoodState();
}

class _AddMoodState extends State<AddMood> {
  MoodQuadrant? selectedMoodQuadrant;
  Mood? selectedMood;
  String? moodNotes;
  List<String> tags = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.addMood)),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 10),
              Container(
                width: 350,
                height: 350,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: selectedMoodQuadrant == null
                    ? Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedMoodQuadrant =
                                            MoodQuadrant.highEnergyUnpleasant;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .highEnergyAndUnpleasant,
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedMoodQuadrant =
                                            MoodQuadrant.highEnergyPleasant;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.yellow.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .highEnergyAndPleasant,
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              children: [
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedMoodQuadrant =
                                            MoodQuadrant.lowEnergyUnpleasant;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .lowEnergyAndUnpleasant,
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        selectedMoodQuadrant =
                                            MoodQuadrant.lowEnergyPleasant;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .lowEnergyAndPleasant,
                                            style: const TextStyle(
                                              fontSize: 24.0,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                            textAlign: TextAlign.center,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      )
                    : MoodListWidget(
                        selectedMood: selectedMood,
                        setSelectedMood: setSelectedMood,
                        selectedMoodQuadrant: MoodQuadrant.values.indexOf(
                          selectedMoodQuadrant!,
                        ),
                      ),
              ),
              const SizedBox(height: 15),
              Text(AppLocalizations.of(context)!.notes),
              const SizedBox(height: 10),
              // Textfield
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  onChanged: (value) {
                    moodNotes = value;
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Text(AppLocalizations.of(context)!.tags),
              const SizedBox(height: 10),
              // Textfield
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: TextField(
                  onChanged: (value) {
                    tags = value.split(',').map((e) => e.trim()).toList();
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              //Save
              Container(
                width: 350,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: ElevatedButton(
                  onPressed: saveMood,
                  child: const Text('Save'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  setSelectedMood(Mood p1) {
    setState(() {
      selectedMood = p1;
    });
  }

  Future<void> saveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a mood.')));
      return;
    }

    try {
      final newEntry = Entry(
        date: DateTime.now().toIso8601String(),
        mood: selectedMood!.toString().split('.').last,
        notes: moodNotes,
        tags: tags,
      );
      await Provider.of<EntryNotifier>(context, listen: false).addEntry(newEntry);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mood saved successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving mood: $e')));
    }
    setState(() {
      selectedMood = null;
      selectedMoodQuadrant = null;
      moodNotes = null;
      tags = [];
    });
  }
}

class MoodListWidget extends StatefulWidget {
  const MoodListWidget({
    super.key,
    required this.selectedMood,
    required this.setSelectedMood,
    required this.selectedMoodQuadrant,
  });

  final Mood? selectedMood;
  final Function(Mood) setSelectedMood;
  final int? selectedMoodQuadrant;

  @override
  State<MoodListWidget> createState() => _MoodListWidgetState();
}

class _MoodListWidgetState extends State<MoodListWidget> {
  final viewTransformationController = TransformationController();

  @override
  void initState() {
    super.initState();
    // Zoomed x 2
    viewTransformationController.value = Matrix4.identity().scaled(2.0);

    // Translate based on the selected quadrant.
    if (widget.selectedMoodQuadrant == 0) {
      // upper left corner
      viewTransformationController.value.translate(-85.0, -85.0);
    } else if (widget.selectedMoodQuadrant == 1) {
      // upper right corner
      viewTransformationController.value.translate(85.0, -85.0);
    } else if (widget.selectedMoodQuadrant == 2) {
      // lower left corner
      viewTransformationController.value.translate(-85.0, 85.0);
    } else if (widget.selectedMoodQuadrant == 3) {
      // lower right corner
      viewTransformationController.value.translate(85.0, 85.0);
    }
  }

  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: viewTransformationController,
      minScale: 1.0,
      maxScale: 2.0,
      child: SizedBox(
        width: double.infinity * 2,
        height: double.infinity * 2,
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
            final isSelected = widget.selectedMood == mood;
            return MoodWidget(
              quadrant: quadrant,
              label: label,
              isSelected: isSelected,
              onTap: () {
                widget.setSelectedMood(mood);
              },
            );
          }),
        ),
      ),
    );
  }
}

class MoodWidget extends StatelessWidget {
  const MoodWidget({
    super.key,
    required this.quadrant,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final MoodQuadrant quadrant;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: quadrant == MoodQuadrant.highEnergyUnpleasant
              ? (isSelected ? Colors.red.shade300 : Colors.red.shade200)
              : quadrant == MoodQuadrant.highEnergyPleasant
                  ? (isSelected
                      ? Colors.yellow.shade300
                      : Colors.yellow.shade200)
                  : quadrant == MoodQuadrant.lowEnergyUnpleasant
                      ? (isSelected
                          ? Colors.blue.shade300
                          : Colors.blue.shade200)
                      : quadrant == MoodQuadrant.lowEnergyPleasant
                          ? (isSelected
                              ? Colors.green.shade300
                              : Colors.green.shade200)
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
