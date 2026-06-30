import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final logged = prefs.getBool('logged') ?? false;
  runApp(TLSecurityApp(logged: logged));
}

class TLSecurityApp extends StatelessWidget {
  final bool logged;
  const TLSecurityApp({super.key, required this.logged});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TL Security Enterprise',
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF07111F),
        primaryColor: const Color(0xFF1457FF),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF1457FF),
          secondary: Color(0xFF00E676),
          surface: Color(0xFF101B2B),
        ),
        cardTheme: CardTheme(
          color: const Color(0xFF101B2B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        ),
      ),
      home: logged ? const HomeScreen() : const LoginScreen(),
    );
  }
}
