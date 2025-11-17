import 'package:flutter/material.dart';
import 'package:mood_matrix/database/database_helper.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
import 'package:mood_matrix/models/entry.dart';

enum MoodQuadrant {
  highEnergyUnpleasant,
  highEnergyPleasant,
  lowEnergyUnpleasant,
  lowEnergyPleasant,
}

enum Mood {
  Enraged,
  Stressed,
  Shocked,
  Surprised,
  Festive,
  Ecstatic,
  Fuming,
  Angry,
  Restless,
  Energized,
  Optimistic,
  Excited,
  Repulsed,
  Worried,
  Uneasy,
  Pleasant,
  Hopeful,
  Blissful,
  Disgusted,
  Down,
  Apathetic,
  Ease,
  Content,
  Fulfilled,
  Miserable,
  Lonely,
  Tired,
  Relaxed,
  Restful,
  Balanced,
  Despair,
  Desolate,
  Drained,
  Sleepy,
  Tranquil,
  Serene,
}

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
            const Text("Notes:"),
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
            const Text("Tags (comma-separated):"),
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
      await DatabaseHelper.instance.insertEntry(newEntry);
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

class MoodListWidget extends StatelessWidget {
  MoodListWidget({
    super.key,
    required this.selectedMood,
    required this.setSelectedMood,
    required this.selectedMoodQuadrant,
  });

  final Mood? selectedMood;
  final Function(Mood) setSelectedMood;
  final int? selectedMoodQuadrant;

  final viewTransformationController = TransformationController();

  // Initialize the viewTransformationController in initState.
  initState() {
    // Zoomed x 2
    viewTransformationController.value = Matrix4.identity().scaled(2.0);

    // Translate based on the selected quadrant.
    if (selectedMoodQuadrant == 0) {
      // upper left corner
      viewTransformationController.value =
          viewTransformationController.value..translate(-0.5, -0.5);
    } else if (selectedMoodQuadrant == 1) {
      // upper right corner
      viewTransformationController.value =
          viewTransformationController.value..translate(0.5, -0.5);
    } else if (selectedMoodQuadrant == 2) {
      // lower left corner
      viewTransformationController.value =
          viewTransformationController.value..translate(-0.5, 0.5);
    } else if (selectedMoodQuadrant == 3) {
      // lower right corner
      viewTransformationController.value =
          viewTransformationController.value..translate(0.5, 0.5);
    }
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
            final isSelected = selectedMood == mood;
            return MoodWidget(
              quadrant: quadrant,
              label: label,
              isSelected: isSelected,
              onTap: () {
                setSelectedMood(mood);
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
