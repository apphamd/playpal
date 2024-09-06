import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:playpal/pages/login/auth_page.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Firebase.apps.isEmpty) {
    // Initialize Firebase here
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  }

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const AuthPage(),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          secondary: Colors.amber,
        ),
        textTheme:
            GoogleFonts.ibmPlexSansTextTheme(Theme.of(context).textTheme),
        navigationBarTheme: const NavigationBarThemeData(
          labelTextStyle: MaterialStatePropertyAll(
            TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
