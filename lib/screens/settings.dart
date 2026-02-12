import '../notifier/theme_notifier.dart';
import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../services/settings_service.dart';
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
  final SettingsService _settingsService = SettingsService();

  Future<void> _signInWithGoogle() async {
    try {
      final userCredential = await AuthService().signInWithGoogle();

      if (userCredential != null) {
        if (!mounted) return;
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Signed in with Google!")));
        await AuthService().synchronizeData(); // Synchronize data after sign-in
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to sign in: $e")));
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (!await launchUrl(uri)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not launch $url')));
    }
  }

  void rateApp() {
    _launchUrl(
      'https://play.google.com/store/apps/details?id=de.jelestudios.moodmatrix',
    );
  }

  void contactUs() {
    _launchUrl('mailto:moodmatrix@jelestudios.de');
  }

  void openPlayStore() {
    _launchUrl('https://play.google.com/store/apps/developer?id=jelestudios');
  }

  void openWeb() {
    _launchUrl('https://jelestudios.de');
  }

  void termsOfService() {
    _launchUrl('https://moodmatrix.jelestudios.de/terms');
  }

  void privacyPolicy() {
    _launchUrl('https://moodmatrix.jelestudios.de/privacy');
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
          Center(
            child: ElevatedButton(
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
          ),
          const SizedBox(height: 20),
          Text(
            '${AppLocalizations.of(context)!.fontSize}: ${themeNotifier.fontSize.toStringAsFixed(1)}',
          ),
          Slider(
            value: themeNotifier.fontSize,
            min: 12.0,
            max: 24.0,
            divisions: 6,
            label: themeNotifier.fontSize.round().toString(),
            onChanged: (double value) {
              themeNotifier.setFontSize(value);
              _settingsService.saveThemeSettings(
                themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                themeNotifier.colorScheme,
                value,
              );
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
                    onTap: () {
                      themeNotifier.setColorScheme(colorName);
                      _settingsService.saveThemeSettings(
                        themeNotifier.isDarkMode
                            ? ThemeMode.dark
                            : ThemeMode.light,
                        colorName,
                        themeNotifier.fontSize,
                      );
                    },
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
                  _settingsService.saveThemeSettings(
                    themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light,
                    themeNotifier.colorScheme,
                    themeNotifier.fontSize,
                  );
                },
                thumbColor: WidgetStateProperty.all(
                  themeNotifier.isDarkMode ? Colors.white : Colors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            AppLocalizations.of(context)!.userData,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(
              context,
            )!.ifYouWantToSaveYourDataAcrossDevicesPleaseSignInWithGoogle,
          ),
          Center(
            child: ElevatedButton(
              onPressed: _signInWithGoogle,
              child: Text(AppLocalizations.of(context)!.signInWithGoogle),
            ),
          ),
          const SizedBox(height: 40),
          Text(
            AppLocalizations.of(context)!.feedback,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                onPressed: rateApp,
                child: Text(AppLocalizations.of(context)!.rateThisApp),
              ),
              TextButton(
                onPressed: contactUs,
                child: Text(AppLocalizations.of(context)!.contactUs),
              ),
            ],
          ),
          const SizedBox(height: 40),
          Text(
            AppLocalizations.of(context)!.information,
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              TextButton(
                onPressed: openPlayStore,
                child: Text(AppLocalizations.of(context)!.otherApps),
              ),
              TextButton(
                onPressed: openWeb,
                child: Text(AppLocalizations.of(context)!.ourWebsite),
              ),
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
