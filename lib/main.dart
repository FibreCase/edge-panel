import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:edge_panel/pages/home.dart';
import 'package:edge_panel/pages/wait.dart';
import 'package:edge_panel/providers/time_provider.dart';
import 'package:edge_panel/providers/weather_provider.dart';
import 'package:edge_panel/providers/global_provider.dart';
import 'package:edge_panel/providers/event_provider.dart';
import 'package:edge_panel/providers/message_provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TimeProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => GlobalProvider()),
        ChangeNotifierProvider(create: (_) => EventProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: Consumer<GlobalProvider>(
        builder: (context, globalProvider, child) {
          return MaterialApp(
            title: 'Edge Panel',
            theme: ThemeData(
              colorScheme: .fromSeed(seedColor: globalProvider.themeColor),
              textTheme: GoogleFonts.notoSansTextTheme(
                ThemeData(brightness: Brightness.light).textTheme,
              ),
            ),
            darkTheme: ThemeData(
              colorScheme: .fromSeed(
                seedColor: globalProvider.themeColor,
                brightness: Brightness.dark,
              ),
              textTheme: GoogleFonts.notoSansTextTheme(
                ThemeData(brightness: Brightness.dark).textTheme,
              ),
            ),
            themeMode: globalProvider.isDarkMode
                ? ThemeMode.dark
                : ThemeMode.light,
            debugShowCheckedModeBanner: false,
            home: RotatedBox(
              quarterTurns: 3,
              child: globalProvider.isSocketConnected
                  ? const HomePage()
                  : const WaitPage(),
            ),
          );
        },
      ),
    );
  }
}
