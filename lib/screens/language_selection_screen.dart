import 'package:flutter/material.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
import 'package:mood_matrix/notifier/locale_notifier.dart';
import 'package:provider/provider.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.selectLanguage),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text("${AppLocalizations.of(context)!.english} - english"),
            onTap: () {
              Provider.of<LocaleNotifier>(context, listen: false)
                  .setLocale(const Locale('en', ''));
            },
          ),
          ListTile(
            title: Text("${AppLocalizations.of(context)!.german} - deutsch"),
            onTap: () {
              Provider.of<LocaleNotifier>(context, listen: false)
                  .setLocale(const Locale('de', ''));
            },
          ),
          ListTile(
            title: Text("${AppLocalizations.of(context)!.french} - français"),
            onTap: () {
              Provider.of<LocaleNotifier>(context, listen: false)
                  .setLocale(const Locale('fr', ''));
            },
          ),
          ListTile(
            title: Text("${AppLocalizations.of(context)!.spanish} - español"),
            onTap: () {
              Provider.of<LocaleNotifier>(context, listen: false)
                  .setLocale(const Locale('es', ''));
            },
          ),
        ],
      ),
    );
  }
}
