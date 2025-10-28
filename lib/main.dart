import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'utils/constants.dart';
import 'services/auth_service.dart';
import 'services/workout_service.dart';
import 'services/diet_service.dart';
import 'services/theme_service.dart';


import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/plans_screen.dart';

import 'screens/diet_plans_screen.dart'; 
import 'screens/progress_tracker_screen.dart';
import 'screens/calendar_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/settings_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthService>(create: (_) => AuthService()),
        ChangeNotifierProvider<WorkoutService>(
            create: (_) => WorkoutService()..loadInitialData()),
        ChangeNotifierProvider<DietService>(
            create: (_) => DietService()..loadInitialData()),
        ChangeNotifierProvider<ThemeService>(create: (_) => ThemeService()),
      ],
      child: Consumer<ThemeService>(
        builder: (context, themeService, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: AppStrings.appName,
            theme: themeService.theme,
            initialRoute: '/',
            routes: {
              '/': (_) => const SplashScreen(),
              '/login': (_) => const LoginScreen(),
              '/signup': (_) => const SignupScreen(),
              '/home': (_) => const HomeScreen(),
              '/plans': (_) => const PlansScreen(),
              '/diet': (_) => const DietPlansScreen(), // use DietPlansScreen here
              '/progress': (_) => const ProgressTrackerScreen(),
              '/calendar': (_) => const CalendarScreen(),
              '/profile': (_) => const ProfileScreen(),
              '/settings': (_) => const SettingsScreen(),
            },
          );
        },
      ),
    );
  }

}

