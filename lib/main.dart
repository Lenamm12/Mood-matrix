import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:mood_matrix/l10n/app_localizations.dart';
import 'models/locale_notifier.dart';
import 'models/theme_notifier.dart';
import 'screens/graphs.dart';
import 'screens/history.dart';
import 'screens/add_mood.dart';
import 'screens/settings.dart';
import 'screens/calender.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider(create: (_) => LocaleNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Consumer2<ThemeNotifier, LocaleNotifier>(
      builder: (context, theme, locale, child) {
        return MaterialApp(
          title: 'Mood matrix',
          theme: theme.currentTheme,
          locale: locale.locale,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''), // English, no country code
            Locale('de', ''), // German, no country code
            Locale('fr', ''), // French, no country code
            Locale('es', ''), // Spanish, no country code
          ],
          home: const MyHomePage(),
        );
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 2;

  final List<Widget> _screens = [
    const HistoryScreen(),
    const GraphsScreen(),
    const AddMood(),
    const CalendarScreen(),
    const SettingsScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return Scaffold(
      body:  IndexedStack(index: _selectedIndex, children: _screens),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
              icon: const Icon(Icons.history),
              label: AppLocalizations.of(context)!.history),
          BottomNavigationBarItem(
            icon: const Icon(Icons.auto_graph),
            label: AppLocalizations.of(context)!.graphs,
          ),
          BottomNavigationBarItem(
              icon: const Icon(Icons.add),
              label: AppLocalizations.of(context)!.addMood),
          BottomNavigationBarItem(
            icon: const Icon(Icons.calendar_month),
            label: AppLocalizations.of(context)!.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        backgroundColor: Colors.black,
        selectedItemColor:
            themeNotifier.isDarkMode ? Colors.white : Colors.black,
        unselectedItemColor: Colors.grey,
      ),
    );
  }
}
