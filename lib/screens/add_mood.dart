// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import '/services/firebase_service.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'Select your mood:',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 10),
            Container(
              width: 350,
              height: 350,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child:
                  selectedMoodQuadrant == null
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
                                      padding: EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.red.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: Center(
                                          child: Text(
                                            'High Energy, Unpleasant',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                              fontWeight: FontWeight.w800,
                                            ),
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
                                      padding: EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.yellow.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'High Energy, Pleasant',
                                            style: TextStyle(
                                              fontStyle: FontStyle.italic,
                                            ),
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
                                      padding: EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text(
                                            'Low Energy, Unpleasant',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                            ),
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
                                      padding: EdgeInsets.all(4),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.green.shade200,
                                          borderRadius: BorderRadius.circular(
                                            12.0,
                                          ),
                                        ),
                                        child: const Center(
                                          child: Text('Low Energy, Pleasant'),
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
            Text("Notes:"),
            const SizedBox(height: 10),
            // Textfield
            Container(
              width: 350,
              height: 100,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: TextField(
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
  final FirestoreService _auth = FirestoreService();

  Future<void> saveMood() async {
    if (selectedMood == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please select a mood.')));
      return;
    }
    if (moodNotes == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Please enter some notes.')));
      return;
    }

    try {
      await _auth.addData("mood", {'date': DateTime.now(), 'notes': moodNotes});
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Mood saved successfully!')));
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error saving routine: $e')));
    }
    setState(() {
      selectedMood = null;
      moodNotes = null;
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
            final label = mood.toString().split('.').last;
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
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.0),
            color:
                quadrant == MoodQuadrant.highEnergyUnpleasant
                    ? (isSelected ? Colors.red.shade300 : Colors.red.shade200)
                    : quadrant == MoodQuadrant.highEnergyPleasant
                    ? (isSelected
                        ? Colors.yellow.shade300
                        : Colors.yellow.shade200)
                    : quadrant == MoodQuadrant.lowEnergyUnpleasant
                    ? (isSelected ? Colors.blue.shade300 : Colors.blue.shade200)
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
                style: const TextStyle(fontSize: 12),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
