import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @notes.
  ///
  /// In en, this message translates to:
  /// **'Notes'**
  String get notes;

  /// No description provided for @tags.
  ///
  /// In en, this message translates to:
  /// **'Tags'**
  String get tags;

  /// No description provided for @mood.
  ///
  /// In en, this message translates to:
  /// **'Mood'**
  String get mood;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @search.
  ///
  /// In en, this message translates to:
  /// **'Search'**
  String get search;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search for notes, tags or dates'**
  String get searchHint;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @history.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get history;

  /// No description provided for @graphs.
  ///
  /// In en, this message translates to:
  /// **'Graphs'**
  String get graphs;

  /// No description provided for @addMood.
  ///
  /// In en, this message translates to:
  /// **'Add mood'**
  String get addMood;

  /// No description provided for @calendar.
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @german.
  ///
  /// In en, this message translates to:
  /// **'German'**
  String get german;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get french;

  /// No description provided for @spanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get spanish;

  /// No description provided for @personalization.
  ///
  /// In en, this message translates to:
  /// **'Personalization'**
  String get personalization;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @fontSize.
  ///
  /// In en, this message translates to:
  /// **'Font Size'**
  String get fontSize;

  /// No description provided for @colorScheme.
  ///
  /// In en, this message translates to:
  /// **'Color Scheme'**
  String get colorScheme;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @userData.
  ///
  /// In en, this message translates to:
  /// **'User data'**
  String get userData;

  /// No description provided for @signInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign in with Google'**
  String get signInWithGoogle;

  /// No description provided for @feedback.
  ///
  /// In en, this message translates to:
  /// **'Feedback'**
  String get feedback;

  /// No description provided for @rateThisApp.
  ///
  /// In en, this message translates to:
  /// **'Rate this app'**
  String get rateThisApp;

  /// No description provided for @contactUs.
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// No description provided for @information.
  ///
  /// In en, this message translates to:
  /// **'Information'**
  String get information;

  /// No description provided for @otherApps.
  ///
  /// In en, this message translates to:
  /// **'Other apps'**
  String get otherApps;

  /// No description provided for @ourWebsite.
  ///
  /// In en, this message translates to:
  /// **'Our website'**
  String get ourWebsite;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @ifYouWantToSaveYourDataAcrossDevicesPleaseSignInWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'If you want to save your data across devices, please sign in with Google'**
  String get ifYouWantToSaveYourDataAcrossDevicesPleaseSignInWithGoogle;

  /// No description provided for @pink.
  ///
  /// In en, this message translates to:
  /// **'Pink'**
  String get pink;

  /// No description provided for @purple.
  ///
  /// In en, this message translates to:
  /// **'Purple'**
  String get purple;

  /// No description provided for @blue.
  ///
  /// In en, this message translates to:
  /// **'Blue'**
  String get blue;

  /// No description provided for @beige.
  ///
  /// In en, this message translates to:
  /// **'Beige'**
  String get beige;

  /// No description provided for @noEntries.
  ///
  /// In en, this message translates to:
  /// **'No entries found.'**
  String get noEntries;

  /// No description provided for @highEnergyAndUnpleasant.
  ///
  /// In en, this message translates to:
  /// **'High Energy & Unpleasant'**
  String get highEnergyAndUnpleasant;

  /// No description provided for @highEnergyAndPleasant.
  ///
  /// In en, this message translates to:
  /// **'High Energy & Pleasant'**
  String get highEnergyAndPleasant;

  /// No description provided for @lowEnergyAndUnpleasant.
  ///
  /// In en, this message translates to:
  /// **'Low Energy & Unpleasant'**
  String get lowEnergyAndUnpleasant;

  /// No description provided for @lowEnergyAndPleasant.
  ///
  /// In en, this message translates to:
  /// **'Low Energy & Pleasant'**
  String get lowEnergyAndPleasant;

  /// No description provided for @enraged.
  ///
  /// In en, this message translates to:
  /// **'Enraged'**
  String get enraged;

  /// No description provided for @stressed.
  ///
  /// In en, this message translates to:
  /// **'Stressed'**
  String get stressed;

  /// No description provided for @shocked.
  ///
  /// In en, this message translates to:
  /// **'Shocked'**
  String get shocked;

  /// No description provided for @surprised.
  ///
  /// In en, this message translates to:
  /// **'Surprised'**
  String get surprised;

  /// No description provided for @festive.
  ///
  /// In en, this message translates to:
  /// **'Festive'**
  String get festive;

  /// No description provided for @ecstatic.
  ///
  /// In en, this message translates to:
  /// **'Ecstatic'**
  String get ecstatic;

  /// No description provided for @fuming.
  ///
  /// In en, this message translates to:
  /// **'Fuming'**
  String get fuming;

  /// No description provided for @angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// No description provided for @restless.
  ///
  /// In en, this message translates to:
  /// **'Restless'**
  String get restless;

  /// No description provided for @energized.
  ///
  /// In en, this message translates to:
  /// **'Energized'**
  String get energized;

  /// No description provided for @optimistic.
  ///
  /// In en, this message translates to:
  /// **'Optimistic'**
  String get optimistic;

  /// No description provided for @excited.
  ///
  /// In en, this message translates to:
  /// **'Excited'**
  String get excited;

  /// No description provided for @repulsed.
  ///
  /// In en, this message translates to:
  /// **'Repulsed'**
  String get repulsed;

  /// No description provided for @worried.
  ///
  /// In en, this message translates to:
  /// **'Worried'**
  String get worried;

  /// No description provided for @uneasy.
  ///
  /// In en, this message translates to:
  /// **'Uneasy'**
  String get uneasy;

  /// No description provided for @pleasant.
  ///
  /// In en, this message translates to:
  /// **'Pleasant'**
  String get pleasant;

  /// No description provided for @hopeful.
  ///
  /// In en, this message translates to:
  /// **'Hopeful'**
  String get hopeful;

  /// No description provided for @blissful.
  ///
  /// In en, this message translates to:
  /// **'Blissful'**
  String get blissful;

  /// No description provided for @disgusted.
  ///
  /// In en, this message translates to:
  /// **'Disgusted'**
  String get disgusted;

  /// No description provided for @down.
  ///
  /// In en, this message translates to:
  /// **'Down'**
  String get down;

  /// No description provided for @apathetic.
  ///
  /// In en, this message translates to:
  /// **'Apathetic'**
  String get apathetic;

  /// No description provided for @ease.
  ///
  /// In en, this message translates to:
  /// **'At ease'**
  String get ease;

  /// No description provided for @content.
  ///
  /// In en, this message translates to:
  /// **'Content'**
  String get content;

  /// No description provided for @fulfilled.
  ///
  /// In en, this message translates to:
  /// **'Fulfilled'**
  String get fulfilled;

  /// No description provided for @miserable.
  ///
  /// In en, this message translates to:
  /// **'Miserable'**
  String get miserable;

  /// No description provided for @lonely.
  ///
  /// In en, this message translates to:
  /// **'Lonely'**
  String get lonely;

  /// No description provided for @tired.
  ///
  /// In en, this message translates to:
  /// **'Tired'**
  String get tired;

  /// No description provided for @relaxed.
  ///
  /// In en, this message translates to:
  /// **'Relaxed'**
  String get relaxed;

  /// No description provided for @restful.
  ///
  /// In en, this message translates to:
  /// **'Restful'**
  String get restful;

  /// No description provided for @balanced.
  ///
  /// In en, this message translates to:
  /// **'Balanced'**
  String get balanced;

  /// No description provided for @despair.
  ///
  /// In en, this message translates to:
  /// **'Despair'**
  String get despair;

  /// No description provided for @desolate.
  ///
  /// In en, this message translates to:
  /// **'Desolate'**
  String get desolate;

  /// No description provided for @drained.
  ///
  /// In en, this message translates to:
  /// **'Drained'**
  String get drained;

  /// No description provided for @sleepy.
  ///
  /// In en, this message translates to:
  /// **'Sleepy'**
  String get sleepy;

  /// No description provided for @tranquil.
  ///
  /// In en, this message translates to:
  /// **'Tranquil'**
  String get tranquil;

  /// No description provided for @serene.
  ///
  /// In en, this message translates to:
  /// **'Serene'**
  String get serene;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['de', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'de': return AppLocalizationsDe();
    case 'en': return AppLocalizationsEn();
    case 'es': return AppLocalizationsEs();
    case 'fr': return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
