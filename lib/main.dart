import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'state/app_state.dart';
import 'theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final state = AppState();
  await state.load(); // reads saved progress and settings from the device
  runApp(AppScope(state: state, child: const AccelLabApp()));
}

class AccelLabApp extends StatelessWidget {
  const AccelLabApp({super.key});

  @override
  Widget build(BuildContext context) {
    final s = AppScope.of(context);
    return MaterialApp(
      title: 'AccelLab',
      debugShowCheckedModeBanner: false,
      theme: buildTheme(s.dark),
      builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(textScaler: TextScaler.linear(s.textScale)),
        child: child!,
      ),
      home: const SplashScreen(),
    );
  }
}
