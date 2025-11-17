import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_localizations.dart';
import 'theme_notifier.dart';

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

int getMoodIndex(String mood) {
  return Mood.values.indexWhere((m) => m.toString().split('.').last == mood);
}

int getMoodQuadrantInt(moodIndex) {
  final qIndex = (moodIndex ~/ 6 < 3 ? 0 : 2) + (moodIndex % 6 < 3 ? 0 : 1);
  return qIndex;
}

Color getMoodColor(String mood, BuildContext context) {
  final themeNotifier = Provider.of<ThemeNotifier>(context, listen: false);
  final moodIndex = getMoodIndex(mood);
  if (moodIndex == -1) {
    return Colors.grey; // Default color if mood not found
  }

  final qIndex = getMoodQuadrantInt(moodIndex);
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
