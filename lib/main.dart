import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:easy_localization/easy_localization.dart';

import './bodies/running_body.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ko')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyFitnessRank',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.grey,
        ),
      ),
      home: const MyFitnessRank(),
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
    );
  }
}

class MyFitnessRank extends StatefulWidget {
  const MyFitnessRank({super.key});

  @override
  State<MyFitnessRank> createState() => _MyFitnessRankState();
}

class _MyFitnessRankState extends State<MyFitnessRank> {
  Widget? _currentBody;
  int numberOfSports = 1;
  final Color appColor = Colors.black;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _currentBody = RunningContentsBody(
      onFooterPageSelected: (widget) => setState(() {
        _currentBody = widget;
      }),
      appColor: appColor,
    );
  }

  void _showSportPage(int index) {
    switch (index) {
      case 0:
        setState(() {
          _currentBody = RunningContentsBody(
            onFooterPageSelected: (widget) => setState(() {
              _currentBody = widget;
            }),
            appColor: appColor,
          );
        });
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      endDrawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            SizedBox(
              height: 65,
              child: DrawerHeader(
                decoration: BoxDecoration(color: appColor),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Sports',
                      style: GoogleFonts.orbitron(
                        textStyle: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
            ...List.generate(numberOfSports, (index) {
              return ListTile(
                leading: Image.asset(
                  'assets/images/sport${index + 1}.png',
                  width: 24,
                  height: 24,
                ),
                title: Text(
                  'sport${index + 1}_header'.tr(),
                  style: GoogleFonts.orbitron(
                    textStyle: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: appColor,
                    ),
                  ),
                ),
                onTap: () => _showSportPage(index),
              );
            }),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: appColor,
        title: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () {
              setState(() {
                _currentBody = RunningContentsBody(
                  onFooterPageSelected: (widget) => setState(() {
                    _currentBody = widget;
                  }),
                  appColor: appColor,
                );
              });
            },
            child: Row(
              children: [
                const SizedBox(width: 12),
                Text(
                  'MyFit',
                  style: GoogleFonts.orbitron(
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
                Text(
                  'Rank',
                  style: GoogleFonts.orbitron(
                    textStyle: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.w700,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.apps),
              color: Colors.white,
              onPressed: () {
                Scaffold.of(context).openEndDrawer();
              },
            ),
          ),
        ],
      ),
      body: _currentBody,
    );
  }
}
