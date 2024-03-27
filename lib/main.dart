import 'package:calendar_scheduler/features/home/repositories/schedule_repo.dart';
import 'package:calendar_scheduler/features/home/view_models/schedule_provider.dart';
import 'package:calendar_scheduler/features/home/views/home_screen.dart';
import 'package:calendar_scheduler/features/splash/splash_screen.dart';
import 'package:calendar_scheduler/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark
    ),
  );

  runApp(const CalendarApp());
}

class CalendarApp extends StatelessWidget {
  const CalendarApp({super.key});

  @override
  Widget build(BuildContext context) {
    final repo = ScheduleRepository();
    final provider = ScheduleProvider(repo: repo);

    return ChangeNotifierProvider(
      create: (context) => provider,
      child: MaterialApp(
        title: 'Calendar Scheduler',
        theme: ThemeData(
          primaryColor: const Color(0xFF0DB2B2),
          useMaterial3: true,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        debugShowCheckedModeBanner: false,
        initialRoute: SplashScreen.routeName,
        routes: {
          SplashScreen.routeName: (context) => const SplashScreen(),
          HomeScreen.routeName: (context) => const HomeScreen(),
        },
      ),
    );
  }
}
