import '../models/theme_notifier.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'language_selection_screen.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  Future<void> _signInWithGoogle() async {
    try {
      final userCredential = await AuthService().signInWithGoogle();

      if (userCredential != null) {
        print("Signed in with Google!");
        await AuthService().synchronizeData(); // Synchronize data after sign-in
      }
    } catch (e) {
      print(e); // Handle errors appropriately
    }
  }

  void rateApp() async {
    final Uri url = Uri.parse(
      'https://play.google.com/store/apps/details?id=de.lenazeise.moodmatrix',
    );
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void contactUs() async {
    final Uri url = Uri.parse('mailto:moodmatrix@jelestudios.de');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void openPlayStore() async {
    final Uri url = Uri.parse(
      'https://play.google.com/store/apps/developer?id=jelestudios',
    );
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void openWeb() async {
    final Uri url = Uri.parse('https://jelestudios.de');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void termsOfService() async {
    final Uri url = Uri.parse('https://moodmatrix.jelestudios.de/terms');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  void privacyPolicy() async {
    final Uri url = Uri.parse('https://moodmatrix.jelestudios.de/privacy');
    if (!await launchUrl(url)) {
      throw Exception('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    final colorSchemes = {
      'Pink': Colors.pink[300]!,
      'Purple': Colors.purple[300]!,
      'Blue': Colors.blue,
      'Beige': Colors.brown[200]!,

    };

    return Scaffold(
      appBar: AppBar(title: Text(AppLocalizations.of(context)!.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: <Widget>[
          Text(
            AppLocalizations.of(context)!.personalization,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const LanguageSelectionScreen(),
                ),
              );
            },
            child: Text(AppLocalizations.of(context)!.language),
          ),
          const SizedBox(height: 20),
          Text(
              '${AppLocalizations.of(context)!.fontSize}: ${themeNotifier.fontSize.toStringAsFixed(1)}'),
          Slider(
            value: themeNotifier.fontSize,
            min: 12.0,
            max: 24.0,
            divisions: 6,
            label: themeNotifier.fontSize.round().toString(),
            onChanged: (double value) {
              themeNotifier.setFontSize(value);
            },
          ),
          const SizedBox(height: 20),
          Text(AppLocalizations.of(context)!.colorScheme),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children:
                colorSchemes.entries.map((entry) {
                  final colorName = entry.key;
                  final color = entry.value;
                  final isSelected = themeNotifier.colorScheme == colorName;

                  return GestureDetector(
                    onTap: () => themeNotifier.setColorScheme(colorName),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(8),
                        border:
                            isSelected
                                ? Border.all(color: Colors.black, width: 2)
                                : null,
                      ),
                    ),
                  );
                }).toList(),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(AppLocalizations.of(context)!.darkMode),
              Switch(
                value: themeNotifier.isDarkMode,
                onChanged: (bool value) {
                  themeNotifier.setDarkMode(value);
                },
                thumbColor: WidgetStateProperty.all(
                  themeNotifier.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(AppLocalizations.of(context)!.userData,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context)!
                .ifYouWantToSaveYourDataAcrossDevicesPleaseSignInWithGoogle,
          ),
          Center(
            child: ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text(AppLocalizations.of(context)!.signInWithGoogle),
            ),
          ),
          const SizedBox(height: 40),
          Text(AppLocalizations.of(context)!.feedback,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                onPressed: rateApp,
                child: Text(AppLocalizations.of(context)!.rateThisApp),
              ),
              TextButton(
                  onPressed: contactUs,
                  child: Text(AppLocalizations.of(context)!.contactUs)),
            ],
          ),

          const SizedBox(height: 40),
          Text(AppLocalizations.of(context)!.information,
              style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                onPressed: openPlayStore,
                child: Text(AppLocalizations.of(context)!.otherApps),
              ),
              TextButton(
                  onPressed: openWeb,
                  child: Text(AppLocalizations.of(context)!.ourWebsite)),
            ],
          ),

          const SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                onPressed: termsOfService,
                child: Text(AppLocalizations.of(context)!.termsOfService),
              ),
              TextButton(
                onPressed: privacyPolicy,
                child: Text(AppLocalizations.of(context)!.privacyPolicy),
              ),
            ],
          ),

          Text('${AppLocalizations.of(context)!.version}: 1.0.0'),
        ],
      ),
    );
  }
}
